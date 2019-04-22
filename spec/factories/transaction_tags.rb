FactoryBot.define do
  factory :transaction_tag do
    association :transaction_money, factory: :transaction
    tag
  end
end
