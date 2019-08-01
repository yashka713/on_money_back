class MonthsListSerializer < ActiveModel::Serializer
  attributes :attributes, :type, :id

  def read_attribute_for_serialization(args)
    return @object if args == :id
    return :months_list if args == :type

    {
      label: @object.strftime('%B %Y')
    }
  end
end
