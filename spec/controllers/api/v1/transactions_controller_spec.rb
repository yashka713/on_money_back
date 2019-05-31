require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let!(:user) { create :user }
  let!(:profitable) { create :account, user_id: user.id, currency: 'USD' }
  let!(:chargeable) { create :account, user_id: user.id, currency: 'USD', balance: 1000 }
  let!(:transactions) do
    create_list :transfer, 10,
                profitable: profitable,
                chargeable: chargeable,
                user: user
  end

  before { login_user(user) }

  context 'index' do
    before { get :index }

    it 'response code' do
      expect(response).to have_http_status(:ok)
    end

    context 'response attributes' do
      let(:transfers) { parsed_data_from_body }
      let(:transaction) { Transaction.all.order(date: :desc).first }

      it 'should be Array' do
        expect(transfers).to be_instance_of Array
      end

      it 'should be 5 transfers' do
        expect(transfers.length.to_s).to eq(ENV['DEFAULT_TRANSACTIONS_AMOUNT'])
      end

      it 'should contain transfers' do
        parsed_id(transfers).each { |id| expect(transactions.pluck(:id)).to include(id) }
      end

      it 'should be serialized' do
        data = transfers.first

        expect(data['id'].to_i).to eq(transaction.id)
        expect(data['type']).to eq('transactions')
        expect(data['attributes']['operation_type']).to eq('transfer')
        expect(data['attributes']['from_amount'].to_f).to eq(transaction.from_amount)
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
end
