Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :projects do
    resources :tasks, only: [ :create, :update, :destroy ]
  end

  resources :tasks, only: [ :create, :update, :destroy ]

  get "/tasks/inbox" => "tasks#tasks_without_deadline"
  get "/tasks/this-week" => "tasks#tasks_with_deadline_this_week"
  get "tasks/today", to: "tasks#tasks_with_deadline_today"
  get "tasks/for_project", to: "tasks#tasks_for_project"
end
