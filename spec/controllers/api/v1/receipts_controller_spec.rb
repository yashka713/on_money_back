require 'rails_helper'

RSpec.describe Api::V1::ReceiptsController, type: :controller do
  let!(:user) { create :user }
  let!(:profitable) { create :account, user: user, currency: 'USD' }
  let!(:chargeable) { create :category, user: user, type_of: 'profit' }

  before { login_user(user) }

  context 'destroy' do
    context 'invalid' do
      let!(:profit) { create :profit, chargeable: chargeable, profitable: profitable, user: user }

      before { delete :destroy, params: { transaction_id: profit.id } }

      it 'returns 404 if receipt empty' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'valid' do
      let!(:profit_with_receipt) do
        create :profit, :with_receipt, chargeable: chargeable, profitable: profitable, user: user
      end
      let(:receipt) { profit_with_receipt.receipt }

      context 'for transaction' do
        before { delete :destroy, params: { transaction_id: profit_with_receipt.id } }

        it 'responds with 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'responds with transaction data' do
          data = parsed_data_from_body

          expect(data['id']).to eq(profit_with_receipt.id.to_s)
          expect(data['type']).to eq('transactions')
          expect(data['attributes']['operation_type']).to eq('profit')
          expect(data['attributes']['status']).to eq('active')
        end
      end

      it 'remove receipt from transaction' do
        expect do
          delete :destroy, params: { transaction_id: profit_with_receipt.id }

          profit_with_receipt.reload
        end.to change { profit_with_receipt.receipt }.from(receipt).to(nil)
      end
    end
  end
end
