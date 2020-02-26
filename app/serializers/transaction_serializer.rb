class TransactionSerializer < ActiveModel::Serializer
  attributes(*Transaction.attribute_names.map(&:to_sym) - %i[
    chargeable_type chargeable_id profitable_type profitable_id user_id
  ])

  belongs_to :chargeable
  belongs_to :profitable

  belongs_to :old_chargeable, if: :old_chargeable_included?
  belongs_to :old_profitable, if: :old_profitable_included?

  has_many :tags

  attribute :date
  attribute :status
  attribute :receipt
  attributes :from_symbol, :to_symbol

  def date
    @object.date.strftime('%F')
  end

  def status
    @object.persisted? ? :active : :deleted
  end

  def receipt
    receipt = @object.receipt

    return {} unless receipt

    {
      original: receipt.receipt_url,
      thumbnail: receipt.receipt_url(:thumbnail)
    }
  end

  def from_symbol
    return Money::Currency.new(@object.chargeable.currency).symbol if @object.chargeable.is_a?(Account)

    Money::Currency.new(@object.profitable.currency).symbol
  end

  def to_symbol
    return Money::Currency.new(@object.profitable.currency).symbol if @object.profitable.is_a?(Account)

    Money::Currency.new(@object.chargeable.currency).symbol
  end

  def old_chargeable_included?
    !instance_options[:old_chargeable].nil?
  end

  def old_profitable_included?
    !instance_options[:old_profitable].nil?
  end

  def old_chargeable
    instance_options[:old_chargeable].reload
  end

  def old_profitable
    instance_options[:old_profitable].reload
  end
end
