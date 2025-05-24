Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  #get "/teste", to: "static#index"
  root "static#index"
  
  resources :users
  resources :products do
    resources :lots
    get 'inventory', on: :member, to: 'products#inventory', as: :inventory
  end

  resources :orders do
    resources :orders_lots, only: [:new, :create, :destroy]
  end
  resources :avaliable_lots, only: [:index]

  resources :tables

  get '/login', to: 'sessions#index'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'
  
  patch 'users/:id/update_password', to: 'users#update_password', as: :password_update
end
