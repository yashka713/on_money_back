module Docs
  swagger_schema :AccountCreateCredentials do
    key :required, %i[account]
    property :account do
      key :type, :object
      key :properties,
          name: {
            type: :string,
            example: 'test'
          },
          currency: {
            type: :string,
            example: 'USD'
          },
          balance: {
            type: :double,
            example: 12.35
          },
          note: {
            type: :string,
            example: 'Test account'
          }
    end
  end

  swagger_schema :AccountUpdateCredentials do
    key :required, %i[account]
    property :account do
      key :type, :object
      key :properties,
          name: {
            type: :string,
            example: 'test'
          },
          currency: {
            type: :string,
            example: 'USD'
          },
          note: {
            type: :string,
            example: 'Test account'
          }
    end
  end

  swagger_schema :AccountItem do
    key :type, :object
    property :id do
      key :type, :integer
      key :example, 0
    end
    property :type do
      key :type, :string
      key :example, 'accounts'
    end
    property :attributes do
      key :type, :object
      property :name do
        key :type, :string
        key :example, 'Test'
      end
      property :balance do
        key :type, :string
        key :example, '0.00'
      end
      property :note do
        key :type, :string
        key :example, 'test account'
      end
      property :currency do
        key :type, :string
        key :example, 'USD'
      end
      property :symbol do
        key :type, :string
        key :example, '$'
      end
    end
  end
end
