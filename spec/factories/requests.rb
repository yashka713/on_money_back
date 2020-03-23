FactoryBot.define do
  factory :request do
    email     { Faker::Internet.email }
    description  { Faker::Lorem.sentences }

    factory :recovery_request, class: Request do
      recover_password { 1 }
    end
  end
end
