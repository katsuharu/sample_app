Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  
  get    '/contact', to: 'static_pages#contact'
  get    '/waiting', to: 'static_pages#waiting'
  get    '/check', to: 'users#check'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  post    '/waiting',        to: 'users#entry'
  delete '/logout',  to: 'sessions#destroy'
  resources :users  
  # resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # routesに記載のないurlへのアクセスを全てリダイレクト
  get "*path" => redirect("/")
  root   'static_pages#home'

end