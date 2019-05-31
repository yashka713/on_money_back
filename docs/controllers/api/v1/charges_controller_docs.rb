module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/charges' do
    operation :get do
      key :description, 'Show last charges transactions'
      key :summary, 'Show last charges transactions'
      key :operationId, 'index'
      key :produces, %w[application/json]
      key :tags, %w[Charge]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Charge transaction list'
        schema do
          key :'$ref', :ListOfChargesTransactions
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
      key :description, 'Create a new charge transaction'
      key :summary, 'Create a new charge transaction'
      key :operationId, 'create'
      key :produces, %w[application/json]
      key :tags, %w[Charge]

      parameter do
        key :name, :charge
        key :in, :body
        key :description, 'Charge transaction credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :ChargeCreateCredentials
        end
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 201 do
        key :description, 'New charge transaction was created'
        schema do
          key :'$ref', :ChargeItem
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
              property :detail,
                       type: :string,
                       example: 'Category is not available for this operation'
              property :source,
                       type: :object do
                property :pointer,
                         type: :string,
                         example: '/data/attributes/base'
              end
            end
          end
        end
      end
    end
  end

  swagger_path '/api/v1/charges/{id}' do
    operation :get do
      key :description, 'Show details for charge transaction'
      key :summary, 'Show details for charge transaction'
      key :operationId, 'show'
      key :produces, %w[application/json]
      key :tags, %w[Charge]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Charge transaction Id'
        key :type, :integer
        key :required, true
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Show charge transaction detail'
        schema do
          key :'$ref', :ChargeItem
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
        key :description, 'Error, when user is not owner of this transaction'
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
      key :description, 'Update charge transaction'
      key :summary, 'Update charge transaction'
      key :operationId, 'update'
      key :produces, %w[application/json]
      key :tags, %w[Charge]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Charge transaction Id'
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
        key :name, :charge
        key :in, :body
        key :description, 'Charge transaction credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :ChargeCreateCredentials
        end
      end

      response 200 do
        key :description, 'Charge transaction was updated'
        schema do
          key :'$ref', :ChargeItem
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
        key :description, 'Error, when user is not owner of this transaction'
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
              property :detail, type: :string, example: 'is invalid'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/to'
              end
            end
          end
        end
      end
    end

    operation :delete do
      key :description, 'Destroy charge transaction'
      key :summary, 'Destroy charge transaction'
      key :operationId, 'destroy'
      key :produces, %w[application/json]
      key :tags, %w[Charge]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Charge transaction Id'
        key :type, :integer
        key :required, true
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Charge transaction was destroyed'
        schema do
          key :'$ref', :ChargeItem
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
        key :description, 'Error, when user is not owner of this transaction'
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
