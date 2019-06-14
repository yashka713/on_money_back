require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:mail) { UserMailer.reset_password_email(user, user.password) }
  let(:default_email) { 'no-reply@on-money.stage' }
  let(:subject) { 'Your password has been reset.' }

  context 'reset_password_email' do
    it 'renders the subject' do
      expect(mail.subject).to eq subject
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq [default_email]
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match(user.password)
    end
  end
end
