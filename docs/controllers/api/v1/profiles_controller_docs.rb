module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/profiles/registration' do
    operation :post do
      key :description, 'Create a user and user profile'
      key :summary, 'Create a user and user profile'
      key :operationId, 'registration'
      key :produces, %w[application/json]
      key :tags, %w[Profile]

      parameter do
        key :name, :user
        key :in, :body
        key :description, 'User credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :RegistrationUser
        end
      end

      response 201 do
        key :description, 'New user was registered'
        schema do
          property :data do
            key :type, :object
            key :'$ref', :ProfileItem
          end
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
end
