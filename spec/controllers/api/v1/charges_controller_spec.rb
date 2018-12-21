require 'rails_helper'

RSpec.describe Api::V1::ChargesController, type: :controller do
  let!(:user) { create :user }
  let!(:profitable) { create :category, user: user, type_of: 'charge' }
  let!(:chargeable) { create :account, user_id: user.id, currency: 'USD' }

  before { login_user(user) }

  context 'index' do
    let!(:charges_list) { create_list :charge, 10, profitable: profitable, chargeable: chargeable, user: user }

    before { get :index }

    it 'response code' do
      expect(response).to have_http_status(:ok)
    end

    context 'response attributes' do
      let(:charges) { parsed_data_from_body }
      let(:charge) { Transaction.last_charges(user).last }

      it 'should be Array' do
        expect(charges).to be_instance_of Array
      end

      it 'should be last 5 profits' do
        expect(charges.length).to eq(5)
      end

      it 'should contain all transfers' do
        parsed_id(charges).each { |id| expect(charges_list.pluck(:id)).to include(id) }
      end

      it 'should be serialized' do
        data = charges.last

        expect(data['id'].to_i).to eq(charge.id)
        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('charge')
        expect(data['attributes']['from_amount'].to_f).to eq(charge.from_amount)
        expect(data['attributes']['note']).to eq(charge.note)
        expect(data['attributes']['status']).to eq('active')
        expect(data['attributes']['date']).to eq(charge.date.strftime('%F'))
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
      let(:valid_params) do
        FactoryBot.attributes_for(:charge, to: profitable, from: chargeable, user: user, amount: 100)
      end

      context 'increment' do
        it 'Transaction count by 1' do
          expect do
            post :create, params: { charge: valid_params }
          end.to change { Transaction.count }.by(1)
        end
      end

      context 'response' do
        before { post :create, params: { charge: valid_params } }

        it { expect(response).to have_http_status(:created) }

        it 'should be serialized' do
          data = parsed_data_from_body

          expect(data['type']).to eq('transactions')
          expect(data['attributes']['operation_type']).to eq('charge')
          expect(data['attributes']['from_amount'].to_f).to eq(valid_params[:from_amount])
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
  end

  context 'show' do
    let!(:charge) { create :charge, chargeable: chargeable, profitable: profitable, user: user }

    before { get :show, params: { id: charge.id } }

    it { expect(response).to have_http_status(:ok) }

    it 'should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(charge.id.to_s)
      expect(data['type']).to eq('transactions')
      expect(data['attributes']['operation_type']).to eq('charge')
      expect(data['attributes']['from_amount'].to_f).to eq(charge.from_amount)
      expect(data['attributes']['note']).to eq(charge.note)
      expect(data['attributes']['status']).to eq('active')
      expect(data['attributes']['date']).to eq(charge.date.strftime('%F'))
    end

    it { expect(parsed_body).to include('included') }

    it 'define accounts for transfers' do
      chargeable_acc = parsed_body['included'].first
      profitable_acc = parsed_body['included'].last

      expect(profitable_acc['id']).to eq(profitable.id.to_s)
      expect(chargeable_acc['id']).to eq(chargeable.id.to_s)
    end
  end

  context 'update' do
    let!(:charge) { create :charge, chargeable: chargeable, profitable: profitable, user: user }

    let!(:updatable) { create :category, user_id: user.id, type_of: 'charge' }
    let(:update_params) { FactoryBot.attributes_for(:profit, from: chargeable.id, to: updatable.id, amount: 200) }

    context 'response' do
      before { patch :update, params: { charge: update_params, id: charge.id } }

      it { expect(response).to have_http_status(:ok) }

      it 'should be serialized' do
        data = parsed_data_from_body

        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('charge')
        expect(data['attributes']['from_amount'].to_f).to eq(update_params[:amount])
        expect(data['attributes']['note']).to eq(update_params[:note])
        expect(data['attributes']['status']).to eq('active')
        expect(data['attributes']['date']).to eq(update_params[:date].strftime('%F'))
      end

      it { expect(parsed_body).to include('included') }

      it 'define accounts for transfers' do
        chargeable_acc = parsed_body['included'].first
        profitable_acc = parsed_body['included'].last

        expect(chargeable_acc['id']).to eq(chargeable.id.to_s)
        expect(profitable_acc['id']).to eq(updatable.id.to_s)
      end
    end
  end

  context 'destroy' do
    let!(:charge) { create :charge, chargeable: chargeable, profitable: profitable, user: user }

    context 'decrement' do
      it 'Transaction count by 1' do
        expect do
          delete :destroy, params: { id: charge.id }
        end.to change { Transaction.count }.by(-1)
      end
    end

    context 'response' do
      before { delete :destroy, params: { id: charge.id } }

      it { expect(response).to have_http_status(:ok) }

      it 'should be serialized' do
        data = parsed_data_from_body

        expect(data['id']).to eq(charge.id.to_s)
        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('charge')
        expect(data['attributes']['from_amount'].to_f).to eq(charge.from_amount)
        expect(data['attributes']['note']).to eq(charge.note)
        expect(data['attributes']['status']).to eq('deleted')
        expect(data['attributes']['date']).to eq(charge.date.strftime('%F'))
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
