class TransactionTag < ApplicationRecord
  belongs_to :money_transaction, touch: true, class_name: 'Transaction', optional: true
  belongs_to :tag, touch: true, optional: true
end
