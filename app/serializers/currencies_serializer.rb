class CurrenciesSerializer < ActiveModel::Serializer
  attributes :attributes, :type, :id

  def read_attribute_for_serialization(args)
    return @object.id if args == :id
    return :currency_info if args == :type

    {
      name: @object.name,
      iso_code: @object.iso_code,
      symbol: @object.symbol
    }
  end
end
