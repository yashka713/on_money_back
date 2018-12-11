class User < ApplicationRecord
  EMAIL_REGEXP = /\A[^@\s]+@[^@\s]+\z/
  PASSWORD_FORMAT = /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/x

  has_secure_password

  has_many :accounts, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates_presence_of :email, :password_digest
  validates :email, format: { with: EMAIL_REGEXP }, uniqueness: true

  validates :password, format: { with: PASSWORD_FORMAT, message: :format }, if: :password_digest_changed?
end
