require 'rails_helper'

RSpec.describe 'Authentication Api', type: :request do

  let(:user_props) {FactoryBot.attributes_for(:user)}

  context 'sign-up' do
    context 'valid' do
      it 'create account' do
        post user_registration_path, params: user_props
        expect(response).to have_http_status(:ok)
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
          post user_registration_path, params: user_props.except(:email)
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
        it 'reports non-unique e-mail'
      end
    end
  end

  context 'login' do
    context 'valid' do
      it 'generate access token'
      it 'grants access to resource'
      it 'grants access to resource multiple time'
      it 'logout'
    end
    context 'invalid' do
      it 'rejects credentials'
    end
  end
end
