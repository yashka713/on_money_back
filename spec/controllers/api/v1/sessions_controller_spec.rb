require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let!(:user) { create :user }

  context 'create:' do
    context 'valid' do
      let(:auth_params) { { user: { email: user.email, password: attributes_for(:user)[:password] } } }

      before { post :create, params: auth_params }

      it 'session was created' do
        expect(response).to have_http_status(:ok)
      end

      it 'return current_user info' do
        user_data = parsed_data_from_body

        expect(user_data['type']).to eq('users')
        expect(user_data['attributes']).to include('jwt')
        expect(user_data['attributes']['email']).to eq(user.email)
      end
    end

    context 'invalid' do
      it 'return unauthorized for incorrect credentials' do
        post :create, params: { user: { email: 'auth@', password: 'Passw1' } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'check_user' do
    before { login_user(user) }

    context 'check auth credentials' do
      before { get :check_user }

      it 'return user data' do
        expect(response).to have_http_status(:ok)

        user_data = parsed_data_from_body

        expect(user_data['type']).to eq('users')
        expect(user_data['attributes']).to include('jwt')
        expect(user_data['attributes']['email']).to eq(user.email)
      end
    end
  end
end
