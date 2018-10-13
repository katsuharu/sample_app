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
  patch '/edit_confirm', to: 'users#edit_confirm'
  post   '/confirm', to: 'users#confirm'
  post   'entry',        to: 'users#entry'
  get 'users/profile', to: 'users#profile'
  get 'users/edit', to: 'users#edit'
  post 'users/edit', to: 'users#edit'
  patch 'users/update', to: 'users#update'
  post 'users/create', to: 'users#create'
  # post 'entry/:id', to: 'users#entry'

  get    'users/cancel'
  post  '/edit_confirm', to: 'users#edit_confirm'

  get 'sessions/new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/account_activation',   to: 'sessions#account_activation'

  get   '/hobby', to: 'user_hobbies#hobby'
  post  '/hobby_save',        to: 'user_hobbies#hobby_save'
  post  '/edit',      to:   'user_hobbies#edit'
  post 'user_hobbies/del_hobby'

  post  'tweets/create'
  post  'tweets/btn_create'
  post  'tweets/tweet_create'
  post  'tweets/thread_create'
  post  'tweets/thread_cmd_create'

  post  'chats/create'
  post  'chats/btn_create'
  # match '/auth/:provider/callback', to: 'users#create', via: [:get, :post]

  # 管理者用ページ
  scope :admins do
    get 'daily_lunches/index'
    get 'daily_lunches/new'
    get 'daily_lunches/edit'
    post 'daily_lunches/create'
    post 'daily_lunches/update'
  end
  
  # resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :tweets

  # routesに記載のないurlへのアクセスを全てリダイレクト
  get "*path" => redirect("/")
  root   'users#index'
  # メンテ時のルート
  # root 'static_pages#maintenance'
end