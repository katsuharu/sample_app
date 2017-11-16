Rails.application.routes.draw do
<<<<<<< HEAD
  get 'sessions/new'

  get 'users/new'

  root 'static_pages#home'
  get '/help', to:'static_pages#help'
  get '/about', to:'static_pages#about'
  get '/contact', to:'static_pages#contact'
  get '/signup', to:'users#new'
  post '/signup',  to: 'users#create'

=======
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
>>>>>>> a14ddf20322464f83cf514c0f6eb51c657f5bb00
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
<<<<<<< HEAD
end
=======
end
>>>>>>> a14ddf20322464f83cf514c0f6eb51c657f5bb00
