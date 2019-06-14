require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:accounts) }
  it { should have_many(:transactions) }
  it { should have_many(:categories) }
  it { should have_many(:tags) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password_digest) }

  it { should allow_value('email@addresse.foo').for(:email) }

  context 'password' do
    let(:user) { create(:user) }

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

  context 'reset_password' do
    let(:user) { create(:user) }

    it 'should change user password' do
      expect do
        user.reset_password
      end.to change(user, :password)
    end

    it 'sends an email' do
      expect { user.reset_password }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context 'update_password!' do
    let(:old_password) { '1Crocodile' }
    let(:user) { create(:user, password: old_password) }
    let(:new_password) { '1Horse' }
    let(:wrong_password) { '1Tiger' }
    let(:update_params) do
      {
        old_password: user.password,
        new_password: new_password,
        new_password_confirmation: new_password
      }
    end

    it 'should change user password' do
      expect do
        user.update_password!(update_params)
      end.to change(user, :password)
    end

    it 'should not authenticate with old password' do
      user.update_password!(update_params)

      expect(user.authenticate(old_password)).to be false
    end

    it 'should authenticate with new password' do
      user.update_password!(update_params)

      expect(user.authenticate(new_password)).to eq user
    end

    it 'returns error for wrong params' do
      update_params[:new_password_confirmation] = wrong_password

      user.update_password!(update_params)

      expect(full_messages(user)).to match(/#{I18n.t('user.errors.empty_password')}/)
    end
  end
end
