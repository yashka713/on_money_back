class TransactionSerializer < ActiveModel::Serializer
  attributes(*Transaction.attribute_names.map(&:to_sym) - %i[
    chargeable_type chargeable_id profitable_type profitable_id user_id
  ])

  belongs_to :chargeable
  belongs_to :profitable

  attribute :date
  attribute :status

  def date
    @object.date.strftime('%F')
  end

  def status
    @object.persisted? ? :active : :deleted
  end
end
