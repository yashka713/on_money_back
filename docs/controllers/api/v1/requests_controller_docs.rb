module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/requests' do
    operation :post do
      key :description, 'Create new Request'
      key :summary, 'Request is a question for Support or just password resetting'
      key :operationId, 'create'
      key :produces, %w[application/json]
      key :tags, %w[Request]

      parameter do
        key :name, :request
        key :in, :body
        key :description, 'Request credentials'
        key :type, :json
        key :required, true
        schema do
          key :'$ref', :RequestCreateCredentials
        end
      end

      response 201 do
        key :description, 'New Request was created'
        schema do
          {}
        end
      end
    end
  end
end
