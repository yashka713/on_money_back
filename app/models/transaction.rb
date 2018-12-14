class Transaction < ApplicationRecord
  TYPES = %i[transfer charge profit].freeze

  enum operation_type: TYPES

  belongs_to :chargeable, polymorphic: true
  belongs_to :profitable, polymorphic: true
  belongs_to :user

  validates :date, :from_amount, :to_amount, presence: true

  validate :the_same_accounts, if: :operation_transfer
  validate :date_cannot_be_in_the_future

  scope :last_transfers, ->(user) { user.transactions.where(operation_type: :transfer).order(date: :desc).last(5) }

  validate :note_is_not_empty, if: :operation_transfer

  private

  def note_is_not_empty
    self.note = note.squish
  end

  def operation_transfer
    operation_type == 'transfer'
  end

  def the_same_accounts
    return if chargeable.id != profitable.id

    errors[:base] << I18n.t('account.errors.accounts_match')
  end

  def date_cannot_be_in_the_future
    errors[:base] << I18n.t('errors.messages.on_or_before', restriction: 'current day') if date.present? && date.future?
  end
end
