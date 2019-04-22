FactoryBot.define do
  factory :user do
    email     { Faker::Internet.email }
    password  { 'Password123' }
  end
end
