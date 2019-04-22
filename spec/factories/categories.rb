FactoryBot.define do
  factory :category do
    name        { Faker::Science.element }
    note        { 'test' }
    type_of     { Category::TYPES.sample }
    association :user, factory: :user
  end
end
