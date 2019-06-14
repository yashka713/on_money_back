FactoryBot.define do
  factory :request do
    email     { Faker::Internet.email }
    description  { Faker::Lorem.sentences }

    factory :recover_request do
      recover_password { 1 }
    end
  end
end
