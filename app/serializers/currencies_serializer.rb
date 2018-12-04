class CurrenciesSerializer < ActiveModel::Serializer
  attributes :attributes, :type, :id

  def read_attribute_for_serialization(args)
    return @object.iso_code if args == :id
    return :currency_info if args == :type

    {
      name: @object.name,
      symbol: @object.symbol
    }
  end
end
