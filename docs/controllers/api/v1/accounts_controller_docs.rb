module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/accounts' do
    operation :get do
      key :description, 'All active accounts'
      key :summary, 'All active accounts for current user'
      key :operationId, 'index'
      key :produces, %w[application/json]
      key :tags, %w[Account]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Accounts list'
        schema do
          property :data do
            key :type, :array
            items do
              key :type, :object
              key :'$ref', :AccountItem
            end
          end
        end
      end

      response 401 do
        key :description, 'Error, when jwt is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
        end
      end
    end

    operation :post do
      key :description, 'Create new account'
      key :summary, 'Create new account for current user'
      key :operationId, 'create'
      key :produces, %w[application/json]
      key :tags, %w[Account]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      parameter do
        key :name, :account
        key :in, :body
        key :description, 'Account credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :AccountCreateCredentials
        end
      end

      response 201 do
        key :description, 'New account was created'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :AccountItem
          end
        end
      end

      response 401 do
        key :description, 'Error, when jwt is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
        end
      end

      response 422 do
        key :description, 'Error, when credentials is incorrect'
        schema do
          key :type, :object
          property :errors do
            key :type, :array
            items do
              property :detail, type: :string, example: 'can\'t be blank'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/name'
              end
            end
          end
        end
      end
    end
  end

  swagger_path '/api/v1/accounts/{id}' do
    operation :get do
      key :description, 'Show info for Account Id'
      key :summary, 'Show account info'
      key :operationId, 'show'
      key :produces, %w[application/json]
      key :tags, %w[Account]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Account Id'
        key :type, :integer
        key :required, true
      end

      response 200 do
        key :description, 'Account info'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :AccountItem
          end
        end
      end

      response 401 do
        key :description, 'Error, when jwt is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
        end
      end

      response 403 do
        key :description, 'Error, when user is not owner of this Account'
        schema do
          key :type, :object
          key :'$ref', :Forbidden
        end
      end

      response 404 do
        key :description, 'Error, when ID is incorrect'
        schema do
          key :type, :object
          key :'$ref', :NotFound
        end
      end
    end

    operation :patch do
      key :description, 'Update info for Account Id'
      key :summary, 'Update account info'
      key :operationId, 'update'
      key :produces, %w[application/json]
      key :tags, %w[Account]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Account Id'
        key :type, :integer
        key :required, true
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      parameter do
        key :name, :account
        key :in, :body
        key :description, 'Account credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :AccountUpdateCredentials
        end
      end

      response 200 do
        key :description, 'Account was updated'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :AccountItem
          end
        end
      end

      response 401 do
        key :description, 'Error, when jwt is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
        end
      end

      response 403 do
        key :description, 'Error, when user is not owner of this Account'
        schema do
          key :type, :object
          key :'$ref', :Forbidden
        end
      end

      response 404 do
        key :description, 'Error, when ID is incorrect'
        schema do
          key :type, :object
          key :'$ref', :NotFound
        end
      end

      response 422 do
        key :description, 'Error, when credentials is incorrect'
        schema do
          key :type, :object
          property :errors do
            key :type, :array
            items do
              property :detail, type: :string, example: 'can\'t be blank'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/name'
              end
            end
          end
        end
      end
    end

    operation :delete do
      key :description, 'Hide account'
      key :summary, 'Hide account of current user'
      key :operationId, 'destroy'
      key :produces, %w[application/json]
      key :tags, %w[Account]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Account Id'
        key :type, :integer
        key :required, true
      end

      response 200 do
        key :description, 'Account was hidden'
        schema do
          key :type, :object
        end
      end

      response 401 do
        key :description, 'Error, when jwt is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
        end
      end

      response 403 do
        key :description, 'Error, when user is not owner of this Account'
        schema do
          key :type, :object
          key :'$ref', :Forbidden
        end
      end

      response 404 do
        key :description, 'Error, when ID is incorrect'
        schema do
          key :type, :object
          key :'$ref', :NotFound
        end
      end
    end
  end
end
