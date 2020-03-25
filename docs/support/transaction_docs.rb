module Docs
  swagger_schema :TransactionItem do
    property :data do
      key :type, :object
      property :id do
        key :type, :integer
        key :example, 0
      end
      property :type do
        key :type, :string
        key :example, 'transactions'
      end
      property :attributes do
        key :type, :object
        property :operation_type do
          key :type, :string
          key :example, 'profit'
        end
        property :from_amount do
          key :type, :integer
          key :example, 100
        end
        property :to_amount do
          key :type, :integer
          key :example, 100
        end
        property :note do
          key :type, :string
          key :example, 'Test'
        end
        property :date do
          key :type, :string
          key :example, '2018-12-10'
        end
        property :status do
          key :type, :string
          key :example, 'deleted'
        end
        property :receipt do
          key :type, :object
          property :filename do
            key :type, :string
            key :example, 'receipt.jpg'
          end
          property :original do
            key :type, :string
            key :example, 'https://s3-path.amazonaws.com/original-receipt.jpg'
          end
          property :thumbnail do
            key :type, :string
            key :example, 'https://s3-path.amazonaws.com/thumbnail-receipt.jpg'
          end
        end
      end
      property :relationships do
        key :type, :object
        property :chargeable do
          key :type, :object
          property :data do
            key :type, :object
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :type do
              key :type, :string
              key :example, 'categories'
            end
          end
        end
        property :profitable do
          key :type, :object
          property :data do
            key :type, :object
            property :id do
              key :type, :integer
              key :example, 2
            end
            property :type do
              key :type, :string
              key :example, 'accounts'
            end
          end
        end
        property :tags do
          key :type, :object
          property :data do
            key :type, :object
            property :id do
              key :type, :integer
              key :example, 1
            end
            property :type do
              key :type, :string
              key :example, 'tags'
            end
          end
        end
      end
    end
    property :included do
      key :type, :array
      items do
        key :type, :object
        key :'$ref', :AccountItem
      end
    end
  end
end
