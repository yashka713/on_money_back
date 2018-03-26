require 'api_constraints'

Rails.application.routes.draw do
  namespace :api do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      resources :people
    end
  end
end
