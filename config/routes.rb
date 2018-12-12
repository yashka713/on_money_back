Rails.application.routes.draw do
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

      resources :docs, only: :index

      resources :transfers

      resources :categories, only: %i[index create show update destroy] do
        collection do
          get :types
        end
      end
    end
  end
end
