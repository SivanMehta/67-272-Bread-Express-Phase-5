BreadExpress::Application.routes.draw do

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :sessions
  resources :users

  
  # Authentication routes
  get 'login' => 'sessions#new', as: :login
  get 'signup' => 'customers#new', as: :signup
  get 'logout' => 'sessions#destroy', as: :logout


  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'search' => 'home#search', as: :search
  get 'cylon' => 'errors#cylon', as: :cylon
  
  # Set the root url
  root :to => 'home#home'
  # Named routes

  patch 'item_prices/:item_id' => 'item_prices#create', as: :create_with_item


  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
