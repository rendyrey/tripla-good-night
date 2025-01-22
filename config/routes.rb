# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post "/sleep-records/clock-in/:user_id", to: "sleep_records#clock_in", as: :clock_in
      patch "/sleep-records/wake-up/:user_id", to: "sleep_records#wake_up", as: :wake_up
      get "/sleep-records", to: "sleep_records#index", as: :sleep_records

      post "/users/:user_id/follow/:followed_user_id", to: "users#follow", as: :follow
      delete "/users/:user_id/unfollow/:followed_user_id", to: "users#unfollow", as: :unfollow
    end
  end
end
