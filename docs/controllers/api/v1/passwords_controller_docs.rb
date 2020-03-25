module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/passwords' do
    operation :patch do
      key :description, 'Update Password for logged in user'
      key :summary, 'Update Password for logged in user'
      key :operationId, 'update'
      key :produces, %w[application/json]
      key :tags, %w[Password]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      parameter do
        key :name, :change_password
        key :in, :body
        key :description, 'Update Password credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :UpdatePasswordCredentials
        end
      end

      response 200 do
        key :description, 'Password updated'
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

      response 422 do
        key :description, 'Error, when credentials is incorrect'
        schema do
          key :type, :object
          property :errors do
            key :type, :array
            items do
              property :detail, type: :string, example: 'Wrong old password or entered information.'
              property :source, type: :object do
                property :pointer, type: :string, example: '/data/attributes/password'
              end
            end
          end
        end
      end
    end
  end
end
