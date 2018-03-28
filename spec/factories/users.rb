FactoryBot.define do
  factory :user do
    name      { Faker::Name.first_name }
    email     { Faker::Internet.email }
    password  'password'
    password_confirmation 'password'
  end
end
