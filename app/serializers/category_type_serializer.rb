class CategoryTypeSerializer < ActiveModel::Serializer
  attributes :attributes, :type, :id

  def read_attribute_for_serialization(args)
    return @object if args == :id
    return :category_type if args == :type

    {}
  end
end
