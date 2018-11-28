Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
  # auth
  get 'authn/whoami'
  get 'authn/checkme'

      resources :profiles, only: %i[] do
        collection do
          post :registration
        end
      end

  namespace :api, defaults: { format: 'json' } do
    end
  end
end
