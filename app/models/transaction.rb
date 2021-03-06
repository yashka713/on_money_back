class Transaction < ApplicationRecord
  include Transferable
  include Profitable
  include Chargeable

  TYPES = %i[transfer charge profit].freeze

  enum operation_type: TYPES

  belongs_to :chargeable, polymorphic: true
  belongs_to :profitable, polymorphic: true
  belongs_to :user

  has_many :transaction_tags, dependent: :destroy, foreign_key: 'money_transaction_id'
  has_many :tags, through: :transaction_tags

  accepts_nested_attributes_for :transaction_tags

  validates :date, :from_amount, :to_amount, presence: true

  validates :from_amount, :to_amount, numericality: { greater_than: 0 }

  validate :date_cannot_be_in_the_future

  validate :operation_between_categories
  validate :owner, if: :chargeable_and_profitable_changed?

  validate :attributes_active, if: :chargeable_and_profitable_changed?

  scope :charges, -> { where(operation_type: :charge) }

  scope :from_accounts, (lambda do |account_ids|
    joins('JOIN accounts ON transactions.chargeable_id = accounts.id')
    .where('accounts.id IN (?)', account_ids)
  end)

  scope :created_between, (lambda do |start_date, end_date|
    where('DATE(date) >= ? AND DATE(date) <= ?', start_date, end_date)
  end)

  scope :monthly_grouped_charges, (lambda do |date, account_ids|
    charges
    .from_accounts(account_ids)
    .created_between(date.beginning_of_month, date.end_of_month)
    .joins('JOIN categories ON transactions.profitable_id = categories.id')
    .group(['categories.name', 'accounts.currency'])
    .sum(:from_amount)
  end)

  before_save :squish_note

  private

  def attributes_active
    return if chargeable.active? && profitable.active?

    errors[:base] << I18n.t('transactions.errors.attributes_hidden')
  end

  def squish_note
    self.note = note.try(:squish)
  end

  def date_cannot_be_in_the_future
    errors[:date] << I18n.t('errors.messages.on_or_before', restriction: 'current day') if date.present? && date.future?
  end

  def operation_between_categories
    return unless chargeable_type == 'Category' && profitable_type == 'Category'

    errors[:base] << I18n.t('transactions.errors.operation_not_allowed')
  end

  def owner
    return if author_owner?

    errors[:base] << I18n.t('transactions.errors.not_owner',
                            chargeable: chargeable.class.name.to_s,
                            profitable: profitable.class.name.to_s)
  end

  def chargeable_and_profitable_changed?
    changes.key?('chargeable_id') || changes.key?('profitable_id')
  end

  def author_owner?
    (chargeable.user == user) && (profitable.user == user)
  end
end
