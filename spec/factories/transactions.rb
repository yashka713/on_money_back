FactoryBot.define do
  factory :transfer, class: Transaction do
    operation_type :transfer
    from_amount 100
    to_amount 100
    note 'Test'
    date Time.now
    association :user, factory: :user
    # Polymorphic Association
    chargeable { |transfer| transfer.association(:account) }
    profitable { |transfer| transfer.association(:account) }
  end
end
