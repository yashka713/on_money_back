class AccountSerializer < ActiveModel::Serializer
  attributes(*Account.attribute_names.map(&:to_sym) - %i[
    created_at updated_at user_id status
  ])

  attribute :symbol
  attribute :balance

  def symbol
    Money::Currency.new(@object.currency).symbol
  end

  def balance
    Money.from_amount(@object.balance).round(2).to_s
  end
end
