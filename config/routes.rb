Rails.application.routes.draw do

  post "/graphql", to: "graphql#execute"
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :sessions, only: %i[create] do
        collection do
          get :check_user
        end
      end

      resources :profiles, only: %i[] do
        collection do
          post :registration
          patch :update
        end
      end

      resources :accounts

      resources :currencies, only: :index

      resources :requests, only: :create

      resources :docs, only: :index

      resources :transfers

      resources :profits

      resources :charges

      resource :passwords, only: [] do
        patch :update, on: :collection
      end

      resources :tags

      resources :transactions, only: :index do
        collection do
          get :months_list
        end
      end

      resources :categories, only: %i[index create show update destroy] do
        collection do
          get :types
        end
      end
    end
  end
end
