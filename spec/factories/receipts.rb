FactoryBot.define do
  factory :receipt do
    association :money_transaction, factory: :transaction
    association :user
  end
end
