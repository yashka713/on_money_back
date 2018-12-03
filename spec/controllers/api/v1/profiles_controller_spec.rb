require 'rails_helper'

RSpec.describe Api::V1::ProfilesController, type: :controller do
  let!(:user) { create :user }
  let(:valid_user_props) { { user: attributes_for(:user) } }
  let(:invalid_user_props) { { user: { email: 'test@', password: 'Passw1' } } }

  context 'registration:' do
    context 'valid' do
      context 'increment' do
        it 'user count by 1' do
          expect do
            post :registration, params: valid_user_props
          end.to change { User.count }.by(1)
        end
      end

      context 'request' do
        before { post :registration, params: valid_user_props }

        it 'check response code' do
          expect(response).to have_http_status(:created)
        end

        it 'check response attributes' do
          user = parsed_data_from_body

          expect(user['type']).to eq('users')
          expect(user['attributes']).to include('jwt')
          expect(user['attributes']['email']).to eq(valid_user_props[:user][:email])
        end
      end

      context 'failure' do
        it 'if email invalid' do
          post :registration, params: invalid_user_props
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'if user exist' do
          User.create(valid_user_props.fetch(:user))
          post :registration, params: valid_user_props
          expect(response.body).to match(/already been taken/)
        end

        it 'if password invalid' do
          post :registration, params: { user: { email: 'test@test', password: 'passw1' } }
          expect(response.body).to match(/at least one upper case/)
        end
      end
    end
  end

  context 'update:' do
    let(:name) { 'Test_First_name' }
    let(:nickname) { 'Test_nickname' }
    let(:update_params) { { user: { name: name, nickname: nickname } } }

    before { login_user(user) }

    context 'successfully updates user' do
      before { patch :update, params: update_params }

      it 'and check response code' do
        expect(response).to have_http_status(:ok)
      end

      it 'and change name' do
        (expect { user.reload }).to change { user.name }.from(nil).to(name)
      end

      it 'and change nickname' do
        (expect { user.reload }).to change { user.nickname }.from(nil).to(nickname)
      end
    end
  end
end
