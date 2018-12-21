module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/categories' do
    operation :get do
      key :description, 'Show all current user categories'
      key :summary, 'Show all current user categories'
      key :operationId, 'index'
      key :produces, %w[application/json]
      key :tags, %w[Category]

      parameter do
        key :name, :type_of
        key :in, :query
        key :description, 'Return only "profits" or "charges" categories'
        key :type, :string
        key :required, false
        key :default, false
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Categories list'
        schema do
          property :data do
            key :type, :array
            items do
              key :type, :object
              key :'$ref', :CategoryItem
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
      key :description, 'Create a new category'
      key :summary, 'Create a new category'
      key :operationId, 'create'
      key :produces, %w[application/json]
      key :tags, %w[Category]

      parameter do
        key :name, :category
        key :in, :body
        key :description, 'Category credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :CategoryCreateCredentials
        end
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 201 do
        key :description, 'New category was created'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :CategoryItem
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
              property :detail, type: :string, example: 'is invalid'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/type_of'
              end
            end
          end
        end
      end
    end
  end

  swagger_path '/api/v1/categories/{id}' do
    operation :get do
      key :description, 'Show details for category'
      key :summary, 'Show details for category'
      key :operationId, 'show'
      key :produces, %w[application/json]
      key :tags, %w[Category]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Category Id'
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
        key :description, 'Show category detail'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :CategoryItem
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
        key :description, 'Error, when user is not owner of this Category'
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
      key :description, 'Update category'
      key :summary, 'Update category'
      key :operationId, 'update'
      key :produces, %w[application/json]
      key :tags, %w[Category]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Category Id'
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
        key :name, :category
        key :in, :body
        key :description, 'Category credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :CategoryUpdateCredentials
        end
      end

      response 200 do
        key :description, 'Category was updated'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :CategoryItem
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
        key :description, 'Error, when user is not owner of this Category'
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
      key :description, 'Destroy category'
      key :summary, 'Destroy category'
      key :operationId, 'destroy'
      key :produces, %w[application/json]
      key :tags, %w[Category]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Category Id'
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
        key :name, :type
        key :in, :query
        key :description, 'operation type(hide full change)'
        key :type, :string
        key :required, true
        key :default, 'hide'
      end

      response 200 do
        key :description, 'Category was destroyed or hidden'
        schema do
          {}
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
        key :description, 'Error, when user is not owner of this Category'
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
        key :description, 'Error, when type is incorrect or empty'
        schema do
          key :type, :object
          property :errors do
            key :type, :array
            items do
              property :detail, type: :string, example: 'Check available types of destroying'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/base'
              end
            end
          end
        end
      end
    end
  end

  swagger_path '/api/v1/categories/types' do
    operation :get do
      key :description, 'Return all available types of categories'
      key :summary, 'Return all available types of categories'
      key :operationId, 'types'
      key :produces, %w[application/json]
      key :tags, %w[Category]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Show available category types'
        schema do
          property :data do
            key :type, :array
            items do
              key :type, :object
              key :'$ref', :CategoryTypeItem
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
  end
end
