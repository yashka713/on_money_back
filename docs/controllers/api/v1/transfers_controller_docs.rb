module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/transfers' do
    operation :get do
      key :description, 'Show last money transfers'
      key :summary, 'Show last money transfers'
      key :operationId, 'index'
      key :produces, %w[application/json]
      key :tags, %w[Transfer]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Transfers list'
        schema do
          key :type, :array
          items do
            key :type, :object
            key :'$ref', :TransferItem
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
      key :description, 'Create a new money transfer'
      key :summary, 'Create a new money transfer'
      key :operationId, 'create'
      key :produces, %w[application/json]
      key :tags, %w[Transfer]

      parameter do
        key :name, :transfer
        key :in, :body
        key :description, 'Transfer credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :TransferCreateCredentials
        end
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 201 do
        key :description, 'New money transfer was created'
        schema do
          key :'$ref', :TransferItem
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
              property :detail, type: :string, example: 'is invalid'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/email'
              end
            end
          end
        end
      end
    end
  end

  swagger_path '/api/v1/transfers/{id}' do
    operation :get do
      key :description, 'Show details for money transfer'
      key :summary, 'Show details for money transfer'
      key :operationId, 'show'
      key :produces, %w[application/json]
      key :tags, %w[Transfer]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Transfer Id'
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
        key :description, 'Show money transfer detail'
        schema do
          key :'$ref', :TransferItem
        end
      end

      response 401 do
        key :description, 'Error, when jwt is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
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

    operation :delete do
      key :description, 'Destroy money transfer'
      key :summary, 'Destroy money transfer'
      key :operationId, 'destroy'
      key :produces, %w[application/json]
      key :tags, %w[Transfer]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Transfer Id'
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
        key :description, 'Money transfer was destroyed'
        schema do
          key :'$ref', :TransferItem
        end
      end

      response 401 do
        key :description, 'Error, when jwt is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
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
      key :description, 'Update money transfer'
      key :summary, 'Update money transfer'
      key :operationId, 'update'
      key :produces, %w[application/json]
      key :tags, %w[Transfer]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Transfer Id'
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
        key :name, :transfer
        key :in, :body
        key :description, 'Transfer credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :TransferCreateCredentials
        end
      end

      response 200 do
        key :description, 'Money transfer was updated'
        schema do
          key :'$ref', :TransferItem
        end
      end

      response 401 do
        key :description, 'Error, when jwt is incorrect'
        schema do
          key :type, :object
          key :'$ref', :Unauthorized
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
  end
end
