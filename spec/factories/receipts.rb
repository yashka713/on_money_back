FactoryBot.define do
  factory :receipt, class: Receipt do
    association :user
    association :money_transaction, factory: :profit

    receipt { Rack::Test::UploadedFile.new('spec/fixtures/receipt.jpg', 'image/jpeg') }
  end
end
