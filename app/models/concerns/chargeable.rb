module Chargeable
  extend ActiveSupport::Concern

  included do
    validate :charges_bills, if: :operation_charge

    scope :last_charges, ->(user) { user.transactions.where(operation_type: :charge).order(date: :desc).last(5) }
  end

  private

  def operation_charge
    operation_type == 'charge'
  end

  def charges_bills
    return if chargeable_type == 'Account' && charge_category

    errors[:base] << I18n.t('transactions.errors.charge_not_allowed')
  end

  def charge_category
    profitable_type == 'Category' && profitable.type_of == 'charge'
  end
end
