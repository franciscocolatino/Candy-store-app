Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # get "/teste", to: "static#index"
  root "static#index"

  resources :users
  resources :avaliable_lots, only: [ :index ]
  resources :tables

  resources :products do
    resources :lots
  end

  resources :orders do
    resources :orders_lots, only: [ :new, :create, :destroy ] do
      member do
        post :order_lot_delivered
      end
    end

    member do
      post :close_order
    end
  end

  get "dashboard", to: "dashboard#show"
  get "delivery", to: "delivery#index"

  get "forbidden", to: "errors#forbidden"
  get "not_found", to: "errors#not_found"

  match "/404", to: "errors#not_found", via: :all
  match "/403", to: "errors#forbidden", via: :all
  match "/500", to: "errors#internal_server_error", via: :all


  get "/login", to: "sessions#index"
  post "/login", to: "sessions#login"
  get "/logout", to: "sessions#logout"

  patch "users/:id/update_password", to: "users#update_password", as: :password_update
end
