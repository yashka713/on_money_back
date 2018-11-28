Rails.application.routes.draw do
  # root
  root to: 'invitations#index'
  # auth
  get 'authn/whoami'
  get 'authn/checkme'

      resources :profiles, only: %i[] do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      # resources will be here
    end
  end
end
