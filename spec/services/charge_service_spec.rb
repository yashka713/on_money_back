require 'rails_helper'

RSpec.describe ChargeService do
  let!(:user) { create(:user) }
  let!(:chargeable) { create :account, user_id: user.id, currency: 'USD', balance: 100 }
  let!(:profitable) { create :category, user_id: user.id, type_of: 'charge' }

  let(:create_params) { FactoryBot.attributes_for(:charge, from: chargeable.id, to: profitable.id, amount: 100) }

  let(:update_params) { FactoryBot.attributes_for(:charge, from: chargeable.id, to: profitable.id, amount: 200) }
  let(:create_transaction) { Transaction.new(user: user, operation_type: :charge) }

  let!(:charge) do
    create :charge, chargeable: chargeable, profitable: profitable, user: user, from_amount: 100, to_amount: 100
  end

  context 'create' do
    let(:service) { ChargeService.new(create_transaction, create_params) }

    it 'increment Transaction count by 1' do
      expect do
        service.create
      end.to change { Transaction.count }.by(1)
    end

    it 'decreases chargeable account amount' do
      expect do
        service.create
        chargeable.reload
      end.to change { chargeable.balance }.from(chargeable.balance).to(chargeable.balance - create_params[:amount])
    end
  end

  context 'update' do
    let(:service) { ChargeService.new(charge, update_params) }

    it 'change Transaction' do
      expect do
        service.update
        charge.reload
      end.to change { charge.from_amount }.from(charge.from_amount).to(update_params[:amount])
    end

    it 'change chargeable account amount' do
      expect do
        service.update
        chargeable.reload
      end.to change { chargeable.balance }
        .from(chargeable.balance)
        .to(charge.from_amount + charge.from_amount - update_params[:amount])
    end
  end

  context 'destroy' do
    let(:service) { ChargeService.new(charge) }

    it 'decrement Transaction count by -1' do
      expect do
        service.destroy
      end.to change { Transaction.count }.by(-1)
    end

    it 'decreases profitable account amount to previous state' do
      expect do
        service.destroy
        chargeable.reload
      end.to change { chargeable.balance }.from(chargeable.balance).to(chargeable.balance + create_params[:amount])
    end
  end
end
