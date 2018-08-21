Rails.application.routes.draw do
  get 'categories/search'

  post   '/contact', to: 'static_pages#send_mail'

  get 'password_resets/new'
  get 'password_resets/edit'
  
  get    '/contact', to: 'static_pages#contact'
  
  post   'users/index'
  get    '/check', to: 'users#check'
  post   'users/check'
  get    '/signup',  to: 'users#new'
  get    'check_entry_cnt',   to: 'users#check_entry_cnt'
  patch '/edit_confirm', to: 'users#edit_confirm'
  post   '/confirm', to: 'users#confirm'
  get   'entry',        to: 'users#entry'
  # post 'entry/:id', to: 'users#entry'

  get    'users/cancel'
  post  '/edit_confirm', to: 'users#edit_confirm'

  get 'sessions/new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get   '/hobby', to: 'user_hobbies#hobby'
  get   '/hobby_show', to: 'user_hobbies#hobby_show'
  post  '/hobby_save',        to: 'user_hobbies#hobby_save'
  post  '/edit',      to:   'user_hobbies#edit'
  post 'user_hobbies/del_hobby'

  post  'tweets/create'
  post  'tweets/btn_create'
  post  'tweets/tweet_create'
  post  'tweets/thread_create'
  post  'tweets/thread_cmd_create'

  post  'chats/create'
  post  'chats/send_mail'

  # match '/auth/:provider/callback', to: 'users#create', via: [:get, :post]
  
  resources :users  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :tweets

  # routesに記載のないurlへのアクセスを全てリダイレクト
  get "*path" => redirect("/")
  root   'users#index'

end