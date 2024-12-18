Rails.application.routes.draw do
  resources :contact_forms, only: %i[new create]

  resources :categories, only: %i[index new create edit update destroy] do
    get "posts", to: "posts#index", as: :posts
  end
  namespace :account do
    resource :password, only: %i[edit update]
  end
  get "search", to: "search#index"
  get "search/autocomplete", to: "search#autocomplete"
  devise_for :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  get "u/:id", to: "users#profile", as: "user"
  resources :posts do
    resources :comments
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :categories, only: %i[index new create edit update destroy]

  # get 'pages/home', to: 'pages#home'
  get "about", to: "pages#about"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
  delete "notifications/:id",
    to: "application#destroy_notification",
    as: "destroy_notification"
end
