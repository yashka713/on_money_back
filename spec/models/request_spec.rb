require 'rails_helper'

RSpec.describe Request, type: :model do
  it { should validate_presence_of(:email) }

  context 'process' do
    let(:email) { 'test_email@example.com' }

    let(:request) { create(:recover_request, email: email) }

    context 'for defined user' do
      let!(:user) { create(:user, email: email) }

      it 'change user password' do
        expect do
          request.process
          user.reload
        end.to change(user, :password_digest)
      end

      it 'sends an email' do
        expect { request.process }
          .to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'add mark to description' do
        request.process
        expect(request.description).to match(/There is problem with user. Write him!/)
      end
    end

    context 'for new user' do
      it 'should not send an email' do
        expect { request.process }
          .to_not change(ActionMailer::Base.deliveries, :count)
      end
    end
  end
end
