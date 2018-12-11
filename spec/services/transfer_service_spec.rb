require 'rails_helper'

RSpec.describe TransferService do
  let(:user) { create(:user) }
  let!(:profitable) { create :account, user_id: user.id, currency: 'USD' }
  let!(:chargeable) { create :account, user_id: user.id, currency: 'USD', balance: 1000 }
  let!(:updatable) { create :account, user_id: user.id, currency: 'USD', balance: 500 }

  let(:create_params) { FactoryBot.attributes_for(:transfer, from: chargeable.id, to: profitable.id, amount: 100) }
  let(:update_params) { FactoryBot.attributes_for(:transfer, from: profitable.id, to: updatable.id, amount: 200) }
  let(:create_transaction) { Transaction.new(user: user, operation_type: :transfer) }

  let!(:transfer) { create :transfer, chargeable: chargeable, profitable: profitable, user: user, amount: 100 }

  context 'create' do
    let(:service) { TransferService.new(create_transaction, create_params) }

    it 'increment Transaction count by 1' do
      expect do
        service.create
      end.to change { Transaction.count }.by(1)
    end

    it 'increases profitable account amount' do
      expect do
        service.create
        profitable.reload
      end.to change { profitable.balance }.from(0).to(profitable.balance + create_params[:amount])
    end

    it 'decreases chargeable account amount' do
      expect do
        service.create
        chargeable.reload
      end.to change { chargeable.balance }.from(chargeable.balance).to(chargeable.balance - create_params[:amount])
    end
  end

  context 'update' do
    let(:service) { TransferService.new(transfer, update_params) }

    it 'increases chargeable account amount to previous state' do
      expect do
        service.update
        chargeable.reload
      end.to change { chargeable.balance }.from(chargeable.balance).to(chargeable.balance + transfer.amount)
    end

    it 'change Transaction' do
      expect do
        service.update
        transfer.reload
      end.to change { transfer.amount }.from(transfer.amount).to(update_params[:amount])
    end

    it 'increases updatable account amount' do
      expect do
        service.update
        updatable.reload
      end.to change { updatable.balance }.from(updatable.balance).to(updatable.balance + update_params[:amount])
    end

    it 'change profitable account amount' do
      new_balance = profitable.balance - update_params[:amount] - transfer.amount
      expect do
        service.update
        profitable.reload
      end.to change { profitable.balance }.from(profitable.balance).to(new_balance)
    end
  end

  context 'destroy' do
    let(:service) { TransferService.new(transfer) }

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

    it 'increases chargeable account amount to previous state' do
      expect do
        service.destroy
        chargeable.reload
      end.to change { chargeable.balance }.from(chargeable.balance).to(chargeable.balance + create_params[:amount])
    end
  end
end
