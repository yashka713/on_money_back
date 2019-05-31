module Docs
  swagger_schema :CategoryCreateCredentials do
    key :required, %i[category]
    property :category do
      key :type, :object
      key :properties,
          type_of: {
            type: :string,
            example: 'charge'
          },
          name: {
            type: :string,
            example: 'test'
          },
          note: {
            type: :string,
            example: 'Test'
          }
    end
  end

  swagger_schema :CategoryUpdateCredentials do
    key :required, %i[category]
    property :category do
      key :type, :object
      key :properties,
          name: {
            type: :string,
            example: 'test'
          },
          note: {
            type: :string,
            example: 'Test'
          }
    end
  end

  swagger_schema :CategoryItem do
    property :id do
      key :type, :integer
      key :example, 0
    end
    property :type do
      key :type, :string
      key :example, 'categories'
    end
    property :attributes do
      key :type, :object
      property :type_of do
        key :type, :string
        key :example, 'charge'
      end
      property :note do
        key :type, :string
        key :example, 'Test'
      end
      property :name do
        key :type, :string
        key :example, 'test'
      end
    end
  end

  swagger_schema :CategoryTypeItem do
    property :id do
      key :type, :string
      key :example, 'charge'
    end
    property :type do
      key :type, :string
      key :example, 'category_type'
    end
    property :attributes do
      nil
    end
  end
end
