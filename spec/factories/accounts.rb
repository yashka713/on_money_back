FactoryBot.define do
  factory :account do
    name { Faker::Commerce.promotion_code }
    association :user, factory: :user
    note { 'test' }
    currency { Account::CURRENCIES_LIST.sample }
    status { :active }
  end
end
