module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/tags' do
    operation :get do
      key :description, 'Show all tags available for current user'
      key :summary, 'Show all tags available for current user'
      key :operationId, 'index'
      key :produces, %w[application/json]
      key :tags, %w[Tag]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Tags list'
        schema do
          property :data do
            key :type, :array
            items do
              key :type, :object
              key :'$ref', :TagItem
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
      key :description, 'Create or find a tag'
      key :summary, 'Create or find a tag'
      key :operationId, 'create'
      key :produces, %w[application/json]
      key :tags, %w[Tag]

      parameter do
        key :name, :tag
        key :in, :body
        key :description, 'Tag credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :TagCreateCredentials
        end
      end

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 201 do
        key :description, 'Tag was found or created'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :TagItem
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
              property :detail, type: :string, example: 'is too long (maximum is 25 characters)'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/name'
              end
            end
          end
        end
      end
    end
  end

  swagger_path '/api/v1/tags/{id}' do
    operation :get do
      key :description, 'Show details for tag'
      key :summary, 'Show details for tag'
      key :operationId, 'show'
      key :produces, %w[application/json]
      key :tags, %w[Tag]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Tag Id'
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
        key :description, 'Show tag detail'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :TagItem
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
        key :description, 'Error, when user is not owner of this Tag'
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
      key :description, 'Update tag'
      key :summary, 'Update tsg'
      key :operationId, 'update'
      key :produces, %w[application/json]
      key :tags, %w[Tag]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Tag Id'
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
        key :name, :tag
        key :in, :body
        key :description, 'Tag credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :TagCreateCredentials
        end
      end

      response 200 do
        key :description, 'Tag was updated'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :TagItem
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
        key :description, 'Error, when user is not owner of this Tag'
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
              property :detail, type: :string, example: 'is too long'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/name'
              end
            end
          end
        end
      end
    end

    operation :delete do
      key :description, 'Destroy tag'
      key :summary, 'Destroy tag'
      key :operationId, 'destroy'
      key :produces, %w[application/json]
      key :tags, %w[Tag]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'Tag Id'
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
        key :description, 'Tag was destroyed'
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
        key :description, 'Error, when user is not owner of this Tag'
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
