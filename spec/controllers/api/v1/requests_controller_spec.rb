require 'rails_helper'

RSpec.describe Api::V1::RequestsController, type: :controller do
  context 'create' do
    let(:request_params) { { request: attributes_for(:request) } }

    context 'only question' do
      before { post :create, params: request_params }

      it 'responds with 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'question with recover password' do
      let!(:user) { create(:user) }
      let(:password_recovery) { { request: attributes_for(:recovery_request, email: user.email) } }

      it 'change user password' do
        expect do
          post :create, params: password_recovery

          user.reload
        end.to change(user, :password_digest)
      end
    end

    it 'increment request count by 1' do
      expect do
        post :create, params: request_params
      end.to change { Request.count }.by(1)
    end
  end
end
