require 'rails_helper'

RSpec.describe Api::V1::ProfitsController, type: :controller do
  let!(:user) { create :user }
  let!(:profitable) { create :account, user_id: user.id, currency: 'USD' }
  let!(:chargeable) { create :category, user: user, type_of: 'profit' }

  before { login_user(user) }

  context 'index' do
    let!(:profits_list) { create_list :profit, 10, profitable: profitable, chargeable: chargeable, user: user }

    before { get :index }

    it 'response code' do
      expect(response).to have_http_status(:ok)
    end

    context 'response attributes' do
      let(:profits) { parsed_data_from_body }
      let(:profit) { Transaction.last_profits(user).last }

      it 'should be Array' do
        expect(profits).to be_instance_of Array
      end

      it 'should be last 5 profits' do
        expect(profits.length).to eq(5)
      end

      it 'should contain all transfers' do
        parsed_id(profits).each { |id| expect(profits_list.pluck(:id)).to include(id) }
      end

      it 'should be serialized' do
        data = profits.last

        expect(data['id'].to_i).to eq(profit.id)
        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('profit')
        expect(data['attributes']['from_amount'].to_f).to eq(profit.from_amount)
        expect(data['attributes']['note']).to eq(profit.note)
        expect(data['attributes']['status']).to eq('active')
        expect(data['attributes']['date']).to eq(profit.date.strftime('%F'))
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
        FactoryBot.attributes_for(:profit, to: profitable, from: chargeable, user: user, amount: 100)
      end

      context 'increment' do
        it 'Transaction count by 1' do
          expect do
            post :create, params: { profit: valid_params }
          end.to change { Transaction.count }.by(1)
        end
      end

      context 'response' do
        before { post :create, params: { profit: valid_params } }

        it { expect(response).to have_http_status(:created) }

        it 'should be serialized' do
          data = parsed_data_from_body

          expect(data['type']).to eq('transactions')
          expect(data['attributes']['operation_type']).to eq('profit')
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
    let!(:profit) { create :profit, chargeable: chargeable, profitable: profitable, user: user }

    before { get :show, params: { id: profit.id } }

    it { expect(response).to have_http_status(:ok) }

    it 'should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(profit.id.to_s)
      expect(data['type']).to eq('transactions')
      expect(data['attributes']['operation_type']).to eq('profit')
      expect(data['attributes']['from_amount'].to_f).to eq(profit.from_amount)
      expect(data['attributes']['note']).to eq(profit.note)
      expect(data['attributes']['status']).to eq('active')
      expect(data['attributes']['date']).to eq(profit.date.strftime('%F'))
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
    let!(:profit) { create :profit, :with_tags, chargeable: chargeable, profitable: profitable, user: user }
    let!(:tag) { create :tag, user_id: user.id }

    let!(:updatable) { create :category, user_id: user.id, type_of: 'profit' }

    let(:update_params) do
      {
        operation_type: :profit,
        from_amount: 100, to_amount: 100,
        note: 'Test',
        date: '2019-04-22',
        from: updatable.id,
        to: profitable.id,
        amount: 200,
        tag_ids: profit.tags.ids << tag.id
      }
    end

    it 'add new tag to profit tags list' do
      expect do
        patch :update, params: { profit: update_params, id: profit.id }
      end.to change { TransactionTag.count }.by(1)
    end

    context 'response' do
      before { patch :update, params: { profit: update_params, id: profit.id } }

      it { expect(response).to have_http_status(:ok) }

      it 'should be serialized' do
        data = parsed_data_from_body

        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('profit')
        expect(data['attributes']['from_amount'].to_f).to eq(update_params[:amount])
        expect(data['attributes']['note']).to eq(update_params[:note])
        expect(data['attributes']['status']).to eq('active')
        expect(data['attributes']['date']).to eq(update_params[:date])
      end

      it { expect(parsed_body).to include('included') }

      it 'contain all affected accounts for profit' do
        account_ids = ids_from_included_which('accounts')
        categories_ids = ids_from_included_which('categories')
        expect(categories_ids).to include(updatable.id)
        expect(account_ids).to include(profitable.id)
      end

      it 'contain all affected tags for profit' do
        tag_ids = ids_from_included_which('tags')
        expect(tag_ids).to include(tag.id)
      end
    end
  end

  context 'destroy' do
    let!(:profit) { create :profit, chargeable: chargeable, profitable: profitable, user: user }

    context 'decrement' do
      it 'Transaction count by 1' do
        expect do
          delete :destroy, params: { id: profit.id }
        end.to change { Transaction.count }.by(-1)
      end
    end

    context 'response' do
      before { delete :destroy, params: { id: profit.id } }

      it { expect(response).to have_http_status(:ok) }

      it 'should be serialized' do
        data = parsed_data_from_body

        expect(data['id']).to eq(profit.id.to_s)
        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('profit')
        expect(data['attributes']['from_amount'].to_f).to eq(profit.from_amount)
        expect(data['attributes']['note']).to eq(profit.note)
        expect(data['attributes']['status']).to eq('deleted')
        expect(data['attributes']['date']).to eq(profit.date.strftime('%F'))
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
