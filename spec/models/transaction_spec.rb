require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:user) { create(:user) }
  let(:chargeable_USD) { create(:account, user: user, currency: 'USD') }
  let(:profitable_USD) { create(:account, user: user, currency: 'USD') }
  let(:profitable_EUR) { create(:account, user: user, currency: 'EUR') }
  let(:valid_transfer) do
    FactoryBot.build(:transfer, chargeable: chargeable_USD, profitable: profitable_USD, user: user)
  end

  it { should define_enum_for(:operation_type).with(Transaction::TYPES) }

  it { should belong_to(:chargeable) }
  it { should belong_to(:profitable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:amount) }

  it { should_not allow_value(Time.now + 1.day).for(:date) }
  it { should allow_value(Time.now).for(:date) }
  it { should allow_value(Time.now + 1).for(:date) }

  it { expect(valid_transfer).to be_valid }

  context 'match_accounts_currency' do
    let(:invalid_transfer) do
      FactoryBot.build(:transfer, chargeable: chargeable_USD, profitable: profitable_EUR, user: user)
    end

    it { expect(invalid_transfer).to_not be_valid }

    it 'should return error' do
      invalid_transfer.save
      expect(full_messages(invalid_transfer)).to match(/#{I18n.t('account.errors.accounts_doesnt_match')}/)
    end
  end

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

  context 'note_is_not_empty' do
    let(:note_empty) { valid_transfer.write_attribute(:note, "    \t \n ") }

    it { expect(valid_transfer.save).to be_truthy }
  end
end