module Docs
  swagger_schema :ChargeCreateCredentials do
    key :required, %i[charge]
    property :charge do
      key :type, :object
      key :properties,
          from: {
            type: :integer,
            example: 0
          },
          to: {
            type: :integer,
            example: 0
          },
          date: {
            type: :string,
            example: '2018-12-05 13:05:32 +0200'
          },
          amount: {
            type: :double,
            example: 1.11
          },
          note: {
            type: :string,
            example: 'Test'
          },
          tag_ids: {
            type: :array,
            example: [1]
          }
    end
  end

  swagger_schema :ChargeItem do
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
          key :example, 'charge'
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
          key :example, 'active'
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
              key :example, 'accounts'
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
              key :example, 'categories'
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

  swagger_schema :ListOfChargesTransactions do
    property :data do
      key :type, :array
      items do
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
            key :example, 'charge'
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
            key :example, 'active'
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
                key :example, 'accounts'
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
                key :example, 'categories'
              end
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
