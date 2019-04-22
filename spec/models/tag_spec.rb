require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:transaction_tags).dependent(:destroy) }
  it { should have_many(:money_transactions).through(:transaction_tags) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(25) }
end
