module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/currencies' do
    operation :get do
      key :description, 'All available currencies'
      key :summary, 'All available currencies'
      key :operationId, 'index'
      key :produces, %w[application/json]
      key :tags, %w[Currency]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'Currencies list'
        schema do
          property :data do
            key :type, :array
            items do
              key :type, :object
              key :'$ref', :CurrencyItem
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
