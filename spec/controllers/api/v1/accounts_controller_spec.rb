require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do
  let!(:user) { create :user }
  let!(:account) { create :account, user_id: user.id }

  before { login_user(user) }

  context 'render_404_if_hidden' do
    let(:hidden_account) { create :account, user_id: user.id, status: 'hidden' }
    before { get :show, params: { id: hidden_account.id } }

    it 'responds with 404' do
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'index' do
    let!(:active_accounts) { create_list :account, 10, user_id: user.id }
    let!(:deleted_accounts) { create_list :account, 10, user_id: user.id, status: :hidden }

    before { get :index }

    it 'response code' do
      expect(response).to have_http_status(:ok)
    end

    context 'response attributes' do
      let(:accounts) { parsed_data_from_body }

      it 'should be Array' do
        expect(accounts).to be_instance_of Array
      end

      it 'should contain only active accounts' do
        ids = parsed_id(accounts)
        expect(ids.sort).to eq((active_accounts.pluck(:id) << account.id).sort)
      end

      it 'should be serialized' do
        data = accounts.first

        expect(data['id'].to_i).to eq(account.id)
        expect(data['type']).to eq('accounts')
        expect(data['attributes']).to include('symbol')
        expect(data['attributes']['name']).to eq(account.name)
        expect(data['attributes']['balance'].to_f).to eq(account.balance)
        expect(data['attributes']['note']).to eq(account.note)
        expect(data['attributes']['currency']).to eq(account.currency)
      end

      it 'should not contain deleted accounts' do
        ids = parsed_id(accounts)
        expect(ids.sort).to_not include(deleted_accounts.pluck(:id).sort)
      end
    end
  end

  context 'create' do
    let(:balance) { 12.35 }
    let(:account_params) { FactoryBot.attributes_for(:account, user_id: user.id, balance: balance) }

    it 'increment account count by 1' do
      expect do
        post :create, params: { account: account_params }
      end.to change { Account.count }.by(1)
    end

    context 'response' do
      before { post :create, params: { account: account_params } }

      it 'responds with 201' do
        expect(response).to have_http_status(:created)
      end

      it 'response attributes should be serialized' do
        account = parsed_data_from_body

        expect(account['type']).to eq('accounts')
        expect(account['attributes']).to include('symbol')
        expect(account['attributes']['name']).to eq(account_params[:name])
        expect(account['attributes']['balance'].to_f).to eq(balance)
        expect(account['attributes']['note']).to eq(account_params[:note])
        expect(account['attributes']['currency']).to eq(account_params[:currency])
      end
    end
  end

  context 'show' do
    before { get :show, params: { id: account.id } }

    it 'should responds with ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'response attributes should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(account.id.to_s)
      expect(data['type']).to eq('accounts')
      expect(data['attributes']).to include('symbol')
      expect(data['attributes']['name']).to eq(account.name)
      expect(data['attributes']['balance'].to_f).to eq(account.balance)
      expect(data['attributes']['note']).to eq(account.note)
      expect(data['attributes']['currency']).to eq(account.currency)
    end
  end

  context 'update' do
    let(:new_name) { 'new_test_name' }
    let(:update_params) { { name: new_name } }

    before { patch :update, params: { id: account.id, account: update_params } }

    it 'should responds with ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'response attributes should be serialized' do
      data = parsed_data_from_body

      expect(data['id']).to eq(account.id.to_s)
      expect(data['type']).to eq('accounts')
      expect(data['attributes']['name']).to eq(new_name)
    end
  end

  context 'destroy' do
    it 'should responds with ok' do
      delete :destroy, params: { id: account.id }

      expect(response).to have_http_status(:ok)
    end

    it 'decrement count active accounts by 1' do
      expect do
        delete :destroy, params: { id: account.id }
      end.to change { Account.active_accounts(user).length }.by(-1)
    end
  end
end
