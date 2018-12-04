class Account < ApplicationRecord
  STATUSES = %i[active deleted].freeze

  CURRENCIES_LIST = Money::Currency.stringified_keys.to_a.map(&:upcase)

  enum status: STATUSES

  belongs_to :user

  validates :balance, numericality: { only_float: true }, allow_nil: true
  validates :name, :currency, presence: true
  validates :currency, inclusion: { in: CURRENCIES_LIST,
                                    message: I18n.t('currency.errors.unknown_currency') }

  scope :active_accounts, ->(user) {  user.accounts.where(status: :active) }

  before_create :set_start_account_amount

  def destroy
    deleted!
  end

  private

  def set_start_account_amount
    self.balance = 0.00 if balance.nil?
  end
end
