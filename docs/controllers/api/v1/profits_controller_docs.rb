module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/profits' do
    operation :get do
      key :description, 'Show last profit transactions'
      key :summary, 'Show last profit transactions'
      key :operationId, 'index'
      key :produces, %w[application/json]
      key :tags, %w[Profit]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Profit transaction list'
        schema do
          key :'$ref', :ListOfProfitsTransactions
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
      key :description, 'Create a new profit transaction'
      key :summary, 'Create a new profit transaction'
      key :operationId, 'create'
      key :produces, %w[application/json]
      key :tags, %w[Profit]

      parameter do
        key :name, :profit
        key :in, :body
        key :description, 'Profit transaction credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :ProfitCreateCredentials
        end
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 201 do
        key :description, 'New profit transaction was created'
        schema do
          key :'$ref', :ProfitItem
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
                       example: 'Allowed operation where profitable is Account and chargable is Category'
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

  swagger_path '/api/v1/profits/{id}' do
    operation :get do
      key :description, 'Show details for profit transaction'
      key :summary, 'Show details for profit transaction'
      key :operationId, 'show'
      key :produces, %w[application/json]
      key :tags, %w[Profit]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Profit transaction Id'
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
        key :description, 'Show profit transaction detail'
        schema do
          key :'$ref', :ProfitItem
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

    operation :delete do
      key :description, 'Destroy profit transaction'
      key :summary, 'Destroy profit transaction'
      key :operationId, 'destroy'
      key :produces, %w[application/json]
      key :tags, %w[Profit]

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
        key :description, 'Profit transaction was destroyed'
        schema do
          key :'$ref', :ProfitItem
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
      key :description, 'Update profit transaction'
      key :summary, 'Update profit transaction'
      key :operationId, 'update'
      key :produces, %w[application/json]
      key :tags, %w[Profit]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Profit transaction Id'
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
        key :name, :profit
        key :in, :body
        key :description, 'Profit transaction credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :ProfitCreateCredentials
        end
      end

      response 200 do
        key :description, 'Profit transaction was updated'
        schema do
          key :'$ref', :ProfitItem
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
  end
end
