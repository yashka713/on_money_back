module Docs
  swagger_schema :CurrencyItem do
    key :type, :object
    property :id do
      key :type, :string
      key :example, 'USD'
    end
    property :type do
      key :type, :string
      key :example, 'currency_info'
    end
    property :attributes do
      key :type, :object
      property :name do
        key :type, :string
        key :example, 'United States Dollar'
      end
      property :symbol do
        key :type, :string
        key :example, '$'
      end
    end
  end
end
