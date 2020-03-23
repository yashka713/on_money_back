FactoryBot.define do
  factory :transfer_transaction_tag, class: TransactionTag do
    association :transaction_money, factory: :transfer
    tag
  end

  factory :charge_transaction_tag, class: TransactionTag do
    association :transaction_money, factory: :charge
    tag
  end

  factory :profit_transaction_tag, class: TransactionTag do
    association :transaction_money, factory: :profit
    tag
  end
end
