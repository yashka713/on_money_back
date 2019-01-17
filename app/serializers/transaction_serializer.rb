class TransactionSerializer < ActiveModel::Serializer
  attributes(*Transaction.attribute_names.map(&:to_sym) - %i[
    chargeable_type chargeable_id profitable_type profitable_id user_id
  ])

  belongs_to :chargeable
  belongs_to :profitable

  attribute :date
  attribute :status
  attributes :from_symbol, :to_symbol

  def date
    @object.date.strftime('%F')
  end

  def status
    @object.persisted? ? :active : :deleted
  end

  def from_symbol
    return Money::Currency.new(@object.chargeable.currency).symbol if @object.chargeable.is_a?(Account)

    Money::Currency.new(@object.profitable.currency).symbol
  end

  def to_symbol
    return Money::Currency.new(@object.profitable.currency).symbol if @object.profitable.is_a?(Account)

    Money::Currency.new(@object.chargeable.currency).symbol
  end
end
