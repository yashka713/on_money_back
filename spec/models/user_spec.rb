require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password_digest) }

  it { should allow_value('email@addresse.foo').for(:email) }
end
