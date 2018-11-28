require 'rails_helper'

describe 'Auth:', type: :request do
  let!(:user) { create :user }

  context 'jwt session' do
    context 'valid' do
      let(:valid_jwt) { Auth.issue(user.id) }

      it 'checks, that token is correct' do
        get '/api/v1/sessions/check_user', headers: { 'Authorization' => "Bearer #{valid_jwt}" }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'invalid' do
      let(:invalid_jwt) { Auth.issue(user.email) }

      it 'checks, that token is incorrect' do
        get '/api/v1/sessions/check_user', headers: { 'Authorization' => "Bearer #{invalid_jwt}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'expired' do
      before { ENV['TOKEN_LIFETIME'] = '-100' }
      after { ENV['TOKEN_LIFETIME'] = '100' }

      it 'checks, that token is expired' do
        get '/api/v1/sessions/check_user', headers: { 'Authorization' => "Bearer #{Auth.issue(user.id)}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
