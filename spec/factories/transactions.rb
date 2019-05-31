FactoryBot.define do
  factory :transfer, class: Transaction do
    operation_type { :transfer }
    from_amount { 100 }
    to_amount { 100 }
    note { 'Test' }
    date { Time.now }
    association :user, factory: :user

    # Polymorphic Association
    chargeable { |transfer| transfer.association(:account) }
    profitable { |transfer| transfer.association(:account) }

    trait :with_tags do
      after(:build) do |transfer|
        transfer.tags << build(:tag, user: transfer.user)
      end
    end
  end

  factory :profit, class: Transaction do
    operation_type { :profit }
    from_amount { 100 }
    to_amount { 100 }
    note { 'Test' }
    date { Time.now }
    association :user, factory: :user

    # Polymorphic Association
    chargeable { |profit| profit.association(:category) }
    profitable { |profit| profit.association(:account) }
    trait :with_tags do
      after(:build) do |profit|
        profit.tags << build(:tag, user: profit.user)
      end
    end
  end

  factory :charge, class: Transaction do
    operation_type { :charge }
    from_amount { 100 }
    to_amount { 100 }
    note { 'Test' }
    date { Time.now }
    association :user, factory: :user

    # Polymorphic Association
    chargeable { |charge| charge.association(:account) }
    profitable { |charge| charge.association(:category) }
    trait :with_tags do
      after(:build) do |charge|
        charge.tags << build(:tag, user: charge.user)
      end
    end
  end
end
