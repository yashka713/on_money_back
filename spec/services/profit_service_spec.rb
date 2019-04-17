require 'rails_helper'

RSpec.describe ProfitService do
  let!(:user) { create(:user) }
  let!(:profitable) { create :account, user_id: user.id, currency: 'USD', balance: 100 }
  let!(:chargeable) { create :category, user_id: user.id, type_of: 'profit' }

  let(:create_params) { FactoryBot.attributes_for(:profit, from: chargeable.id, to: profitable.id, amount: 100) }

  let(:update_params) { FactoryBot.attributes_for(:profit, from: chargeable.id, to: profitable.id, amount: 200) }
  let(:create_transaction) { Transaction.new(user: user, operation_type: :profit) }

  let!(:profit) do
    create :profit, chargeable: chargeable, profitable: profitable, user: user, from_amount: 100, to_amount: 100
  end

  context 'create' do
    let(:service) { ProfitService.new(create_transaction, create_params) }

    it 'increment Transaction count by 1' do
      expect do
        service.create
      end.to change { Transaction.count }.by(1)
    end

    it 'increases profitable account amount' do
      expect do
        service.create
        profitable.reload
      end.to change { profitable.balance }.from(profitable.balance).to(profitable.balance + create_params[:amount])
    end
  end

  context 'update' do
    let(:service) { ProfitService.new(profit, update_params) }

    it 'change Transaction' do
      expect do
        service.update
        profit.reload
      end.to change { profit.from_amount }.from(profit.from_amount).to(update_params[:amount])
    end

    it 'change profitable account amount' do
      expect do
        service.update
        profitable.reload
      end.to change { profitable.balance }
        .from(profitable.balance)
        .to(profit.to_amount - profit.from_amount + update_params[:amount])
    end
  end

  context 'destroy' do
    let(:service) { ProfitService.new(profit) }

    it 'decrement Transaction count by -1' do
      expect do
        service.destroy
      end.to change { Transaction.count }.by(-1)
    end

    it 'decreases profitable account amount to previous state' do
      expect do
        service.destroy
        profitable.reload
      end.to change { profitable.balance }.from(profitable.balance).to(profitable.balance - create_params[:amount])
    end
  end
end
