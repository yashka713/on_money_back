require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:user) { create(:user) }

  it { should define_enum_for(:status).with_values(Account::STATUSES) }

  it { should belong_to(:user) }
  it { should have_many(:charges) }
  it { should have_many(:profits) }

  it { should validate_numericality_of(:balance).allow_nil }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:currency) }

  context 'destroy' do
    let(:account) { create(:account, user: user) }

    it 'should update status to :deleted' do
      expect { account.destroy }.to change { account.status }.from('active').to('hidden')
    end
  end

  context 'set_start_account_amount' do
    context 'if balance does not set up' do
      let(:account_attributes) { FactoryBot.attributes_for(:account, user_id: user.id) }
      let(:account) { Account.create(account_attributes) }

      it 'should define balance as 0.00' do
        expect(account.balance).to be(0.0)
      end
    end

    context 'if balance set up with zero params' do
      let(:zero_balance) { FactoryBot.attributes_for(:account, balance: 0.00, user_id: user.id) }
      let(:account) { Account.create(zero_balance) }

      it 'should define balance as 0.00' do
        expect(account.balance).to be(0.0)
      end
    end

    context 'if balance set up with non zero params' do
      let(:non_zero_balance) { FactoryBot.attributes_for(:account, balance: 12.35, user_id: user.id) }
      let(:account) { Account.create(non_zero_balance) }

      it 'should define balance as defined' do
        expect(account.balance).to be(non_zero_balance[:balance])
      end
    end
  end

  context 'check_currency_type' do
    let(:valid_currency_type) do
      FactoryBot.attributes_for(:account, user_id: user.id, currency: Account::CURRENCIES_LIST.sample)
    end

    it 'checks, that account is valid' do
      expect(Account.create(valid_currency_type)).to be_valid
    end

    context 'invalid' do
      let(:invalid_currency_type) do
        FactoryBot.attributes_for(:account, user_id: user.id, currency: 'hrn')
      end

      it 'checks, that account does not valid' do
        expect(Account.create(invalid_currency_type)).to_not be_valid
      end

      it 'returns error' do
        account = Account.create(invalid_currency_type)
        expect(full_messages(account)).to match(/#{I18n.t('currency.errors.unknown_currency')}/)
      end
    end
  end
end
