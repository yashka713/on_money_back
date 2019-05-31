module Transferable
  extend ActiveSupport::Concern

  included do
    validate :operation_between_accounts, if: :operation_transfer
    validate :the_same_accounts, if: :operation_transfer

    scope :last_transfers, ->(user) { user.transactions.where(operation_type: :transfer).order(date: :desc).last(5) }
  end

  private

  def operation_between_accounts
    return if chargeable_type == 'Account' && profitable_type == 'Account'

    errors[:base] << I18n.t('transactions.errors.transfer_not_allowed')
  end

  def operation_transfer
    operation_type == 'transfer'
  end

  def the_same_accounts
    return unless chargeable.id == profitable.id

    errors[:base] << I18n.t('account.errors.accounts_match')
  end
end
