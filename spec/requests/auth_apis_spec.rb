require 'rails_helper'

RSpec.describe 'Authentication Api', type: :request do
  let(:user_props) { FactoryBot.attributes_for(:user) }

  context 'sign-up' do
    context 'valid' do
      it 'create account' do
        signup(user_props)
        payload = JSON.parse(response.body)
        expect(payload).to include('status' => 'success')
        expect(payload).to include('data')
        expect(payload['data']).to include('id')
        expect(payload['data']).to include('provider' => 'email')
        expect(payload['data']).to include('uid' => user_props[:email])
        expect(payload['data']).to include('name' => user_props[:name])
        expect(payload['data']).to include('email' => user_props[:email])
      end
    end

    context 'invalid' do
      context 'missing information' do
        it 'reports error with messages' do
          signup(user_props.except(:email), :unprocessable_entity)
          expect(response).to have_http_status(:unprocessable_entity)
          payload = JSON.parse(response.body)
          expect(payload).to include('status' => 'error')
          expect(payload).to include('errors')
          expect(payload['errors']).to include('email')
          expect(payload['errors']).to include('full_messages')
          expect(payload['errors']['full_messages']).to include(/Email/i)
        end
      end

      context 'non-unique information' do
        it 'reports non-unique e-mail' do
          signup(user_props)
          post user_registration_path, params: user_props
          payload = JSON.parse(response.body)
          expect(payload).to include("status"=>"error")
          expect(payload).to include("errors")
          expect(payload["errors"]).to include("email")
          expect(payload["errors"]).to include("full_messages")
          expect(payload["errors"]["full_messages"]).to include(/Email/i)
        end
      end
    end
  end

  context 'anonymous user' do
    it 'allow access to info' do
      get authn_whoami_path
      expect(response).to have_http_status(:ok)
    end
    it 'doesn\'t allow access to info' do
      get authn_checkme_path
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'login' do
    let(:account) { signup(user_props, :ok) }
    context 'valid' do
      it 'generate access token' do
        login account.slice(:email, :password)
        expect(response.headers).to include('uid')
        expect(response.headers).to include('access-token')
        expect(response.headers).to include('client')
        expect(response.headers).to include('token-type')
      end
      it 'logout' do
        post user_session_path, params: { email: account[:email], password: account[:password] }
        expect(response).to have_http_status(:ok)
        logout(get_cred(response), :ok)
        expect(access_tokens?).to be false
        get authn_checkme_path # , access_tokens
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'invalid' do
      it 'rejects credentials' do
        login account.merge(:password=>"badpassword"), :unauthorized
      end
    end
  end
end
