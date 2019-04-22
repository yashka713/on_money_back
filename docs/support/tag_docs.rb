module Docs
  swagger_schema :TagCreateCredentials do
    key :required, %i[tag]
    property :tag do
      key :type, :object
      key :properties,
          name: {
            type: :string,
            example: 'test'
          }
    end
  end

  swagger_schema :TagItem do
    property :id do
      key :type, :integer
      key :example, 0
    end
    property :type do
      key :type, :string
      key :example, 'tags'
    end
    property :attributes do
      key :type, :object
      property :name do
        key :type, :string
        key :example, 'test'
      end
    end
  end
end
