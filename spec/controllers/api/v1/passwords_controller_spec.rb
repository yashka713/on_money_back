require 'rails_helper'

RSpec.describe Api::V1::PasswordsController, type: :controller do
  let(:old_password) { '1Crocodile' }
  let!(:user) { create(:user, password: old_password) }
  let(:new_password) { '1Horse' }
  let(:wrong_password) { '1Tiger' }
  let(:valid_password_params) do
    {
      change_password: {
        old_password: old_password,
        new_password: new_password,
        new_password_confirmation: new_password
      }
    }
  end

  let(:invalid_password_params) do
    {
      change_password: {
        old_password: old_password,
        new_password: new_password,
        new_password_confirmation: wrong_password
      }
    }
  end

  before { login_user(user) }

  context 'update:' do
    context 'if valid, ' do
      context 'change ' do
        it 'user could authenticate with new passwords' do
          expect(user.authenticate(old_password)).to eq user

          put :update, params: valid_password_params

          user.reload
          expect(user.authenticate(old_password)).to eq false
        end

        it 'user authenticate with new passwords' do
          expect do
            put :update, params: valid_password_params

            user.reload
          end.to change(user, :password_digest)
        end
      end

      context 'request' do
        before { patch :update, params: valid_password_params }

        it 'check response code' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'if not valid' do
        context 'and passwords does not match' do
          before { put :update, params: invalid_password_params }

          it 'will be 422 status' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'shows error' do
            expect(response.body).to match(I18n.t('user.errors.empty_password'))
          end
        end
      end
    end
  end
end
