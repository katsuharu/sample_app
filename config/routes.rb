Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  
  get    '/contact', to: 'static_pages#contact'
  get    '/check', to: 'users#check'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  get    '/entry',   to: 'users#check_entry_cnt'
  get     '/hobby', to: 'user_hobbies#hobby'

  post   '/login',   to: 'sessions#create'
  post   '/confirm', to: 'users#confirm'
  post   '/entry',        to: 'users#entry'
  post   '/cancel',        to: 'users#cancel'
  post   '/contact', to: 'static_pages#send_mail'
  post  '/edit_confirm', to: 'users#edit_confirm'
  post   '/hobby_save',        to: 'user_hobbies#hobby_save'

  patch '/edit_confirm', to: 'users#edit_confirm'

  delete '/logout',  to: 'sessions#destroy'

  # match '/auth/:provider/callback', to: 'users#create', via: [:get, :post]
  
  resources :users  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # routesに記載のないurlへのアクセスを全てリダイレクト
  get "*path" => redirect("/")
  root   'users#index'

end