require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password_digest) }

  it { should allow_value('email@addresse.foo').for(:email) }

  context 'password' do
    it 'should be valid' do
      expect(user).to be_valid
    end

    context 'not valid' do
      %w[password123 Passwordpass Pasw1].each do |word|
        let(:new_user) { build(:user, password: word) }

        it { should_not be_valid }

        it word.to_s do
          new_user.valid?
          expect(full_messages(new_user)).to match(/#{I18n.t('activerecord.errors.models.user.attributes.password.format')}/)
        end
      end
    end
  end
end