module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/transactions' do
    operation :get do
      key :description, 'Show last transactions'
      key :summary, 'Show last transactions'
      key :operationId, 'index'
      key :produces, %w[application/json]
      key :tags, %w[Transaction]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      parameter do
        key :name, 'page[number]'
        key :in, :query
        key :description, 'Page number'
        key :type, :integer
        key :required, false
      end

      parameter do
        key :name, 'page[size]'
        key :in, :query
        key :description, 'Amount of transactions'
        key :type, :integer
        key :required, false
      end

      response 200 do
        key :description, 'Transactions list'
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
  end
end
