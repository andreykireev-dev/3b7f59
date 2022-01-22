Rails.application.routes.draw do
    resources :warmup, only: [:index]

    namespace :api do
        resources :users, only: [:create]
        post "/login", to: "users#login"
        get "/user", to: "users#user"
        get "/campaigns", to: "campaigns#show"
        get "/campaigns/search", to: "campaigns#search"
        post "/campaigns", to: "campaigns#create"
        post "/campaigns/:id/prospects", to: "campaigns#add_prospects"
        get "/prospects", to: "prospects#show"
        post "/prospects", to: "prospects#create"
        post "/prospects_files/import", to: "prospect_imports#create"
    end
end
