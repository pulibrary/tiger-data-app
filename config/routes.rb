# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get "sign_in", to: "devise/sessions#new", as: :new_user_session
    get "sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "welcome#index"

  resources :organizations
  resources :projects
  post "projects/:id/approve", to: "projects#approve", as: :project_approve

  get "dashboards/:role", to: "dashboards#show"

  namespace :api do
    namespace :v0 do
      resources :projects, only: [:index]
    end
  end
end
