require 'rails_helper'

RSpec.describe Api::V1::TransfersController, type: :controller do
  let!(:user) { create :user }
  let!(:profitable) { create :account, user_id: user.id, currency: 'USD' }
  let!(:chargeable) { create :account, user_id: user.id, currency: 'USD', balance: 1000 }

  before { login_user(user) }

  context 'index' do
    let!(:transactions) do
      create_list :transfer, 10,
                  profitable: profitable,
                  chargeable: chargeable,
                  user: user,
                  amount: (1...200).to_a.sample
    end

    before { get :index }

    it 'response code' do
      expect(response).to have_http_status(:ok)
    end

    context 'response attributes' do
      let(:transfers) { parsed_data_from_body }
      let(:transaction) { Transaction.last_transfers(user).last }

      it 'should be Array' do
        expect(transfers).to be_instance_of Array
      end

      it 'should be 5 transfers' do
        expect(transfers.length).to eq(5)
      end

      it 'should contain all transfers' do
        parsed_id(transfers).each { |id| expect(transactions.pluck(:id)).to include(id) }
      end

      it 'should be serialized' do
        data = transfers.last

        expect(data['id'].to_i).to eq(transaction.id)
        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('transfer')
        expect(data['attributes']['amount'].to_f).to eq(transaction.amount)
        expect(data['attributes']['note']).to eq(transaction.note)
        expect(data['attributes']['status']).to eq('active')
        expect(data['attributes']['date']).to eq(transaction.date.strftime('%F'))
      end
    end

    context 'included' do
      it { expect(parsed_body).to include('included') }

      it 'define accounts for transfers' do
        chargeable_acc = parsed_body['included'].first
        profitable_acc = parsed_body['included'].last

        expect(profitable_acc['id']).to eq(profitable.id.to_s)
        expect(chargeable_acc['id']).to eq(chargeable.id.to_s)
      end
    end
  end

  context 'create' do
    context 'valid' do
      let(:valid_params) { FactoryBot.attributes_for(:transfer, to: profitable, from: chargeable, user: user) }

      context 'increment' do
        it 'Transaction count by 1' do
          expect do
            post :create, params: { transfer: valid_params }
          end.to change { Transaction.count }.by(1)
        end
      end

      context 'response' do
        before { post :create, params: { transfer: valid_params } }

        it { expect(response).to have_http_status(:created) }

        it 'should be serialized' do
          data = parsed_data_from_body

          expect(data['type']).to eq('transactions')
          expect(data['attributes']['operation_type']).to eq('transfer')
          expect(data['attributes']['amount'].to_f).to eq(valid_params[:amount])
          expect(data['attributes']['note']).to eq(valid_params[:note])
          expect(data['attributes']['status']).to eq('active')
          expect(data['attributes']['date']).to eq(valid_params[:date].strftime('%F'))
        end

        it { expect(parsed_body).to include('included') }

        it 'define accounts for transfers' do
          chargeable_acc = parsed_body['included'].first
          profitable_acc = parsed_body['included'].last

          expect(profitable_acc['id']).to eq(profitable.id.to_s)
          expect(chargeable_acc['id']).to eq(chargeable.id.to_s)
        end
      end
    end

    context 'invalid' do
      let(:invalid_params) { FactoryBot.attributes_for(:transfer, to: profitable, from: profitable, user: user) }

      before { post :create, params: { transfer: invalid_params } }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'checks error' do
        expect(response.body).to match(/#{I18n.t('account.errors.accounts_match')}/)
      end
    end
  end

  context 'update' do
    let!(:transfer) { create :transfer, chargeable: chargeable, profitable: profitable, user: user }

    let!(:updatable) { create :account, user_id: user.id, currency: 'USD', balance: 500 }
    let(:update_params) { FactoryBot.attributes_for(:transfer, from: profitable.id, to: updatable.id, amount: 200) }

    context 'response' do
      before { patch :update, params: { transfer: update_params, id: transfer.id } }

      it { expect(response).to have_http_status(:ok) }

      it 'should be serialized' do
        data = parsed_data_from_body

        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('transfer')
        expect(data['attributes']['amount'].to_f).to eq(update_params[:amount])
        expect(data['attributes']['note']).to eq(update_params[:note])
        expect(data['attributes']['status']).to eq('active')
        expect(data['attributes']['date']).to eq(update_params[:date].strftime('%F'))
      end

      it { expect(parsed_body).to include('included') }

      it 'define accounts for transfers' do
        chargeable_acc = parsed_body['included'].first
        profitable_acc = parsed_body['included'].last

        expect(profitable_acc['id']).to eq(updatable.id.to_s)
        expect(chargeable_acc['id']).to eq(profitable.id.to_s)
      end
    end
  end

  context 'show' do
    let!(:transfer) { create :transfer, chargeable: chargeable, profitable: profitable, user: user }

    before { get :show, params: { id: transfer.id } }

    it { expect(response).to have_http_status(:ok) }

    it 'should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(transfer.id.to_s)
      expect(data['type']).to eq('transactions')
      expect(data['attributes']['operation_type']).to eq('transfer')
      expect(data['attributes']['amount'].to_f).to eq(transfer.amount)
      expect(data['attributes']['note']).to eq(transfer.note)
      expect(data['attributes']['status']).to eq('active')
      expect(data['attributes']['date']).to eq(transfer.date.strftime('%F'))
    end

    it { expect(parsed_body).to include('included') }

    it 'define accounts for transfers' do
      chargeable_acc = parsed_body['included'].first
      profitable_acc = parsed_body['included'].last

      expect(profitable_acc['id']).to eq(profitable.id.to_s)
      expect(chargeable_acc['id']).to eq(chargeable.id.to_s)
    end
  end

  context 'destroy' do
    let!(:transfer) { create :transfer, chargeable: chargeable, profitable: profitable, user: user }

    context 'decrement' do
      it 'Transaction count by 1' do
        expect do
          delete :destroy, params: { id: transfer.id }
        end.to change { Transaction.count }.by(-1)
      end
    end

    context 'response' do
      before { delete :destroy, params: { id: transfer.id } }

      it { expect(response).to have_http_status(:ok) }

      it 'should be serialized' do
        data = parsed_data_from_body

        expect(data['id']).to eq(transfer.id.to_s)
        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('transfer')
        expect(data['attributes']['amount'].to_f).to eq(transfer.amount)
        expect(data['attributes']['note']).to eq(transfer.note)
        expect(data['attributes']['status']).to eq('deleted')
        expect(data['attributes']['date']).to eq(transfer.date.strftime('%F'))
      end

      it { expect(parsed_body).to include('included') }

      it 'define accounts for transfers' do
        chargeable_acc = parsed_body['included'].first
        profitable_acc = parsed_body['included'].last

        expect(profitable_acc['id']).to eq(profitable.id.to_s)
        expect(chargeable_acc['id']).to eq(chargeable.id.to_s)
      end
    end
  end
end
