require 'rails_helper'

RSpec.describe TransferService do
  let(:user) { create(:user) }
  let!(:profitable) { create :account, user_id: user.id, currency: 'USD', balance: 100 }
  let!(:profitable_eur) { create :account, user_id: user.id, currency: 'EUR' }
  let!(:chargeable) { create :account, user_id: user.id, currency: 'USD', balance: 1000 }
  let!(:updatable) { create :account, user_id: user.id, currency: 'USD', balance: 500 }

  let(:create_params) do
    FactoryBot.attributes_for(:transfer, from: chargeable.id, to: profitable.id, amount: 100)
  end

  let(:update_params) { FactoryBot.attributes_for(:transfer, from: profitable.id, to: updatable.id, amount: 200) }
  let(:create_transaction) { Transaction.new(user: user, operation_type: :transfer) }

  let!(:transfer) do
    create :transfer, chargeable: chargeable, profitable: profitable, user: user, from_amount: 100, to_amount: 100
  end

  context 'create' do
    context 'when currencies the same' do
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
        end.to change { profitable.balance }.from(profitable.balance).to(profitable.balance + create_params[:amount])
      end

      it 'decreases chargeable account amount' do
        expect do
          service.create
          chargeable.reload
        end.to change { chargeable.balance }.from(chargeable.balance).to(chargeable.balance - create_params[:amount])
      end
    end

    context 'when currencies are different' do
      let(:rate) { 2 }
      let(:diff_currencies_params) do
        FactoryBot.attributes_for(:transfer, from: chargeable.id, to: profitable_eur.id, amount: 100, rate: rate)
      end
      let(:service) { TransferService.new(create_transaction, diff_currencies_params) }

      it 'increases profitable account to rate times' do
        expect do
          service.create
          profitable_eur.reload
        end.to change { profitable_eur.balance }
          .from(profitable_eur.balance)
          .to(profitable_eur.balance + (diff_currencies_params[:amount] * rate))
      end

      it 'decreases chargeable account amount for set amount' do
        expect do
          service.create
          chargeable.reload
        end.to change { chargeable.balance }
          .from(chargeable.balance)
          .to(chargeable.balance - diff_currencies_params[:amount])
      end

      context 'match_accounts_currency' do
        let(:invalid_currencies_params) do
          FactoryBot.attributes_for(:transfer, from: chargeable.id, to: profitable_eur.id, amount: 100)
        end
        let(:service) { TransferService.new(create_transaction, invalid_currencies_params) }

        it 'should return error' do
          service.create
          expect(full_messages(service.transaction)).to match(/#{I18n.t('account.errors.rate.empty')}/)
        end
      end
    end
  end

  context 'update' do
    let(:service) { TransferService.new(transfer, update_params) }

    context 'when currencies the same' do
      it 'increases chargeable account amount to previous state' do
        expect do
          service.update
          chargeable.reload
        end.to change { chargeable.balance }.from(chargeable.balance).to(chargeable.balance + transfer.from_amount)
      end

      it 'change Transaction' do
        expect do
          service.update
          transfer.reload
        end.to change { transfer.from_amount }.from(transfer.from_amount).to(update_params[:amount])
      end

      it 'increases updatable account amount' do
        expect do
          service.update
          updatable.reload
        end.to change { updatable.balance }.from(updatable.balance).to(updatable.balance + update_params[:amount])
      end

      it 'change profitable account amount' do
        expect do
          service.update
          profitable.reload
        end.to change { profitable.balance }.from(profitable.balance).to(profitable.balance - update_params[:amount])
      end
    end

    context 'when currencies are different' do
      let(:rate) { 5 }
      let(:diff_currencies_params) do
        FactoryBot.attributes_for(:transfer, from: chargeable.id, to: profitable_eur.id, amount: 100, rate: rate)
      end
      let!(:transfer) do
        create :transfer,
               chargeable: chargeable,
               profitable: profitable,
               user: user
      end
      let(:service) { TransferService.new(transfer, diff_currencies_params) }

      it 'change profitable account amount, set balance which was before transfer' do
        old_prof_balance = profitable.balance
        expect do
          service.update
          profitable.reload
        end.to change { profitable.balance }.from(profitable.balance).to(profitable.balance - old_prof_balance)
      end

      it 'change chargeable account amount' do
        expect do
          service.update
          chargeable.reload
        end.to change { chargeable.balance }
          .from(chargeable.balance)
          .to(chargeable.balance - diff_currencies_params[:amount])
      end

      it 'change new profitable account amount' do
        expect do
          service.update
          profitable_eur.reload
        end.to change { profitable_eur.balance }
          .from(profitable_eur.balance)
          .to(profitable_eur.balance + (diff_currencies_params[:amount] * rate))
      end
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
