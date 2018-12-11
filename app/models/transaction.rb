class Transaction < ApplicationRecord
  TYPES = %i[transfer charge profit].freeze

  enum operation_type: TYPES

  belongs_to :chargeable, polymorphic: true
  belongs_to :profitable, polymorphic: true
  belongs_to :user

  validates :date, :amount, presence: true
  # validates date using "validates_timeliness" gem
  validates_date :date, on_or_before: -> { Date.current }

  validate :match_accounts_currency, if: :operation_transfer
  validate :the_same_accounts, if: :operation_transfer
  validate :note_is_not_empty, if: :operation_transfer, on: :create

  scope :last_transfers, ->(user) { user.transactions.where(operation_type: :transfer).order(date: :desc).last(5) }

  private

  def note_is_not_empty
    self.note = nil if note.nil? || note.squish.empty?
  end

  def operation_transfer
    operation_type == 'transfer'
  end

  def match_accounts_currency
    return if chargeable.currency.eql? profitable.currency

    errors[:base] << I18n.t('account.errors.accounts_doesnt_match')
  end

  def the_same_accounts
    return if chargeable.id != profitable.id

    errors[:base] << I18n.t('account.errors.accounts_match')
  end
end
