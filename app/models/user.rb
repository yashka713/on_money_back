require 'securerandom'

class User < ApplicationRecord
  EMAIL_REGEXP = /\A[^@\s]+@[^@\s]+\z/.freeze
  PASSWORD_FORMAT = /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/x.freeze

  has_secure_password

  has_many :accounts, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates_presence_of :email, :password_digest
  validates :email, format: { with: EMAIL_REGEXP }, uniqueness: true

  validates :password, format: { with: PASSWORD_FORMAT, message: :format }, if: :password_digest_changed?

  def update_password!(password_params)
    if authenticate(password_params[:old_password]) && same_password_params?(password_params)
      self.password = password_params[:new_password]
      save
    else
      errors[:password] << I18n.t('user.errors.empty_password')
    end
  end

  def reset_password
    new_passw = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz') # from Devise
    self.password = new_passw
    UserMailer.reset_password_email(self, new_passw).deliver_now if save
  end

  private

  def same_password_params?(password_params)
    password_params[:new_password] == password_params[:new_password_confirmation]
  end
end
