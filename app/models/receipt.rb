class Receipt < ApplicationRecord
  include ReceiptUploader::Attachment(:receipt)

  belongs_to :money_transaction, touch: true, class_name: 'Transaction', optional: true
  has_one :user, through: :money_transaction

  after_save :derivate_receipt

  private

  def derivate_receipt
    receipt_derivatives! if receipt_changed? && receipt
  end
end
