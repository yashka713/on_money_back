Rails.application.routes.draw do
  # root
  root to: 'invitations#index'
  # auth
  get 'authn/whoami'
  get 'authn/checkme'

  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      # resources will be here
    end
  end
end
