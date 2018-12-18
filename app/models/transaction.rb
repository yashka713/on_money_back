class Transaction < ApplicationRecord
  include Transferable
  include Profitable

  TYPES = %i[transfer charge profit].freeze

  enum operation_type: TYPES

  belongs_to :chargeable, polymorphic: true
  belongs_to :profitable, polymorphic: true
  belongs_to :user

  validates :date, :from_amount, :to_amount, presence: true

  validate :date_cannot_be_in_the_future

  validate :note_is_not_empty
  validate :operation_between_categories

  private

  def note_is_not_empty
    self.note = note.try(:squish)
  end

  def date_cannot_be_in_the_future
    errors[:base] << I18n.t('errors.messages.on_or_before', restriction: 'current day') if date.present? && date.future?
  end

  def operation_between_categories
    return unless chargeable_type == 'Category' && profitable_type == 'Category'

    errors[:base] << I18n.t('transactions.errors.operation_not_allowed')
  end
end
