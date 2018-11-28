module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/sessions' do
    operation :post do
      key :description, 'Sign In User'
      key :summary, 'Sign In User'
      key :operationId, 'create'
      key :produces, %w[application/json]
      key :tags, %w[Session]

      parameter do
        key :name, :user
        key :in, :body
        key :description, 'User credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :UserCredentials
        end
      end

      response 200 do
        key :description, 'User successfully signed in'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :ProfileItem
          end
        end
      end

      response 401 do
        key :description, 'Error, when credentials is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
        end
      end
    end
  end

  swagger_path '/api/v1/sessions/check_user' do
    operation :post do
      key :description, 'Check jwt token'
      key :summary, 'Check jwt token and return user data if it is correct'
      key :operationId, 'check_user'
      key :produces, %w[application/json]
      key :tags, %w[Session]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'The old token is correct and not expired'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :ProfileItem
          end
        end
      end

      response 401 do
        key :description, 'Error, when credentials is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
        end
      end
    end
  end
end
