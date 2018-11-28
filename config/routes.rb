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
        end
      end

      resources :docs, only: :index
    end
  end
end
