module Profitable
  extend ActiveSupport::Concern

  included do
    validate :profits_bills, if: :operation_profit

    scope :last_profits, ->(user) { user.transactions.where(operation_type: :profit).order(date: :desc).last(5) }
  end

  private

  def operation_profit
    operation_type == 'profit'
  end

  def profits_bills
    return if chargeable_type == 'Category' && profitable_type == 'Account'

    errors[:base] << I18n.t('transactions.errors.profit_not_allowed')
  end
end
