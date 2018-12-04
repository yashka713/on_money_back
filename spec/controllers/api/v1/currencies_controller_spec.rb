require 'rails_helper'

RSpec.describe Api::V1::CurrenciesController, type: :controller do
  let!(:user) { create :user }
  before { login_user(user) }

  context 'index' do
    context 'request' do
      before { get :index }

      it 'check response code' do
        expect(response).to have_http_status(:ok)
      end

      it 'check response attributes' do
        currencies = parsed_data_from_body

        expect(currencies).to be_instance_of Array

        usd = currencies.first

        expect(usd['id']).to eq('USD')
        expect(usd['type']).to eq('currency_info')
        expect(usd['attributes']).to include('symbol')
        expect(usd['attributes']['name']).to eq('United States Dollar')
      end
    end
  end
end
