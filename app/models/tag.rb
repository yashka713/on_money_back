class Tag < ApplicationRecord
  belongs_to :user
  has_many :transaction_tags, dependent: :destroy
  has_many :money_transactions, through: :transaction_tags

  validates :name, length: { minimum: 3, maximum: 25 }, presence: true
end
