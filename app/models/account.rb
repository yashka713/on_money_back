class Account < ApplicationRecord
  include Searchable

  STATUSES = %i[active hidden].freeze

  CURRENCIES_LIST = Money::Currency.stringified_keys.to_a.map(&:upcase)

  enum status: STATUSES

  belongs_to :user
  has_many :charges, as: :chargeable, class_name: 'Transaction'
  has_many :profits, as: :profitable, class_name: 'Transaction'

  validates :balance, numericality: { only_float: true }, allow_nil: true
  validates :name, :currency, presence: true
  validates :currency, inclusion: { in: CURRENCIES_LIST,
                                    message: I18n.t('currency.errors.unknown_currency') }

  scope :active_accounts, ->(user) {  user.accounts.where(status: :active).order(id: :asc) }

  before_create :set_start_account_amount

  def destroy
    hidden!
  end

  def as_indexed_json(_options = {})
    as_json(only: %i[name currency])
  end

  private

  def set_start_account_amount
    self.balance = 0.00 if balance.nil?
  end
end
