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

  def reset_password!(password_params)
    if password_params[:password] && (password_params[:password] == password_params[:password_confirmation])
      self.password = password_params[:password]
      return true if save

      self.errors[:password] << I18n.t('user.errors.wrong_password')
    else
      self.errors[:password] << I18n.t('user.errors.empty_password')
    end
  end
end
