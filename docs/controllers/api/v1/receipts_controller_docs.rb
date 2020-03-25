module Docs
  include Swagger::Blocks

  swagger_path '/api/v1/transactions/{transaction_id}/receipts' do
    operation :delete do
      key :description, 'Delete all receipts for chosen transaction'
      key :summary, 'Delete all receipts for chosen transaction'
      key :operationId, 'destroy'
      key :produces, %w[application/json]
      key :tags, %w[Receipt]

      parameter do
        key :name, :transaction_id
        key :in, :path
        key :description, 'Transaction Id'
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
        key :description, 'Receipt was destroyed'
        schema do
          key :'$ref', :TransactionItem
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
        key :description, 'Error, when ID is incorrect or receipt empty'
        schema do
          key :type, :object
          key :'$ref', :NotFound
        end
      end
    end
  end
end
