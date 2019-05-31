require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  let(:chargeable_USD) { create(:account, user: user, currency: 'USD') }
  let(:other_chargeable_USD) { create(:account, user: other_user, currency: 'USD') }
  let(:profitable_USD) { create(:account, user: user, currency: 'USD') }
  let(:profitable_EUR) { create(:account, user: user, currency: 'EUR') }

  let(:valid_transfer) do
    FactoryBot.build(:transfer, chargeable: chargeable_USD, profitable: profitable_USD, user: user)
  end

  it { should define_enum_for(:operation_type).with_values(Transaction::TYPES) }

  it { should belong_to(:chargeable) }
  it { should belong_to(:profitable) }
  it { should belong_to(:user) }
  it { should have_many(:transaction_tags).dependent(:destroy).with_foreign_key('money_transaction_id') }
  it { should have_many(:tags).through(:transaction_tags) }

  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:from_amount) }
  it { should validate_presence_of(:to_amount) }

  it { should validate_numericality_of(:to_amount).is_greater_than(0) }
  it { should validate_numericality_of(:from_amount).is_greater_than(0) }

  it { should allow_value(Time.now).for(:date) }
  it { should_not allow_value(Time.now + 1).for(:date) }

  it { expect(valid_transfer).to be_valid }

  context 'squish_note' do
    let(:empty_string) { "    \t \n " }

    it 'squish note before saving' do
      expect do
        valid_transfer.update(note: empty_string)
      end.to change { valid_transfer.note }
        .from(valid_transfer.note)
        .to('')
    end
  end

  context 'owner' do
    context 'invalid' do
      let(:invalid_params) do
        FactoryBot.attributes_for(:transfer, chargeable: other_chargeable_USD, profitable: profitable_USD, user: user)
      end

      it 'should return error if user not owner of chargeable or profitable' do
        error = I18n.t('transactions.errors.not_owner',
                       chargeable: other_chargeable_USD.class.name.to_s,
                       profitable: profitable_USD.class.name.to_s)
        transaction = Transaction.create(invalid_params)
        expect(transaction.errors.full_messages).to include(error)
      end
    end
  end

  context 'date_cannot_be_in_the_future' do
    let(:invalid_transfer) do
      FactoryBot.build(:transfer, chargeable: chargeable_USD, profitable: profitable_USD, date: Time.now + 1.day)
    end

    it { expect(invalid_transfer).to_not be_valid }

    it 'should return error' do
      invalid_transfer.save
      message = full_messages(invalid_transfer)
      expect(message).to match(/#{I18n.t('errors.messages.on_or_before', restriction: 'current day')}/)
    end
  end

  context 'operation_between_categories' do
    let(:category) { create :category, user: user }
    let(:other_category) { create :category, user: user }

    let(:invalid_params) do
      FactoryBot.attributes_for(:profit, chargeable: category, profitable: other_category, user: user)
    end

    it 'should return error if operation between categories' do
      transaction = Transaction.create(invalid_params)
      expect(transaction.errors.full_messages).to include(I18n.t('transactions.errors.operation_not_allowed'))
    end
  end

  context 'concern Transferable' do
    context 'the_same_accounts' do
      let(:invalid_transfer) do
        FactoryBot.build(:transfer, chargeable: chargeable_USD, profitable: chargeable_USD, user: user)
      end

      it { expect(invalid_transfer).to_not be_valid }

      it 'should return error' do
        invalid_transfer.save
        expect(full_messages(invalid_transfer)).to match(/#{I18n.t('account.errors.accounts_match')}/)
      end
    end

    context 'operation_between_accounts' do
      let!(:category) { create :category, user: user }
      let(:invalid_transfer) do
        FactoryBot.build(:transfer, chargeable: category, profitable: chargeable_USD, user: user)
      end

      it 'should return error' do
        invalid_transfer.save
        expect(full_messages(invalid_transfer)).to match(/#{I18n.t('transactions.errors.transfer_not_allowed')}/)
      end
    end
  end

  context 'concern Profitable' do
    context 'profits_bills' do
      let!(:category) { create :category, user: user }
      let(:invalid_profit) do
        FactoryBot.build(:profit, chargeable: chargeable_USD, profitable: category, user: user)
      end

      it 'should return error' do
        invalid_profit.save
        expect(full_messages(invalid_profit)).to match(/#{I18n.t('transactions.errors.profit_not_allowed')}/)
      end
    end
  end

  context 'concern Chargeable' do
    context 'charges_bills' do
      let!(:account) { create :account, user: user }
      let(:invalid_charge) do
        FactoryBot.build(:charge, chargeable: chargeable_USD, profitable: account, user: user)
      end

      it 'should return error' do
        invalid_charge.save
        expect(full_messages(invalid_charge)).to match(/#{I18n.t('transactions.errors.charge_not_allowed')}/)
      end
    end
  end

  context 'attributes_not_hidden' do
    let(:hidden_account) { create :account, user: user, status: :hidden }
    let!(:category) { create :category, user: user, type_of: 'charge' }

    let(:invalid_charge) do
      FactoryBot.build(:charge, chargeable: hidden_account, profitable: category, user: user)
    end

    it 'should return error' do
      invalid_charge.save
      expect(full_messages(invalid_charge)).to match(/#{I18n.t('transactions.errors.attributes_hidden')}/)
    end
  end
end
