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

  swagger_path '/api/v1/transactions/months_list' do
    operation :get do
      key :description, 'Show months list, where were transactions'
      key :summary, 'Show months list, where were transactions'
      key :operationId, 'months_list'
      key :produces, %w[application/json]
      key :tags, %w[Transaction]

      parameter do
        key :'$ref', :TokenParam
        schema do
          key :'$ref', :TokenExample
        end
      end

      response 200 do
        key :description, 'List months where were transactions'
        schema do
          property :data do
            key :type, :array
            items do
              key :type, :object
              property :id do
                key :type, :string
                key :example, '2019-06-01T00:00:00.000Z'
              end
              property :type do
                key :type, :string
                key :example, 'months_list'
              end
              property :attributes do
                key :type, :object
                property :label do
                  key :type, :string
                  key :example, 'July 2019'
                end
              end
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
