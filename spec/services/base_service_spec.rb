require 'rails_helper'

RSpec.describe BaseService do
  let!(:user) { create(:user) }
  let!(:account_1) { create :account, user_id: user.id, currency: 'USD', balance: 100 }
  let!(:account_2) { create :account, user_id: user.id, currency: 'USD', balance: 100 }
  let!(:category_charge) { create :category, user_id: user.id, type_of: 'charge' }
  let!(:category_profit) { create :category, user_id: user.id, type_of: 'profit' }

  let!(:profit) do
    create :profit, chargeable: category_profit, profitable: account_2, user: user, from_amount: 100, to_amount: 100
  end

  let!(:charge) do
    create :charge, chargeable: account_1, profitable: category_charge, user: user, from_amount: 100, to_amount: 100
  end

  let!(:transfer) do
    create :transfer, chargeable: account_1, profitable: account_2, user: user, from_amount: 100, to_amount: 100
  end

  context 'initialize should define which types of attributes will be set' do
    context 'transfer' do
      let(:service) { BaseService.new(transfer) }

      it 'should define 2 Accounts' do
        expect(service.instance_variable_get(:@chargeable)).to eq account_1
        expect(service.instance_variable_get(:@profitable)).to eq account_2
      end
    end

    context 'charge' do
      let(:service) { BaseService.new(charge) }

      it 'should define chargeable as Account and profitable as Category with type "charge"' do
        expect(service.instance_variable_get(:@chargeable)).to eq account_1
        expect(service.instance_variable_get(:@profitable)).to eq category_charge
      end
    end

    context 'profit' do
      let(:service) { BaseService.new(profit) }

      it 'should define chargeable as Category with type "profit" and profitable as Account' do
        expect(service.instance_variable_get(:@chargeable)).to eq category_profit
        expect(service.instance_variable_get(:@profitable)).to eq account_2
      end
    end
  end
end
