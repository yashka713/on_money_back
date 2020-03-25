class Tag < ApplicationRecord
  include Searchable

  belongs_to :user
  has_many :transaction_tags, dependent: :destroy
  has_many :money_transactions, through: :transaction_tags

  validates :name, length: { minimum: 3, maximum: 25 }, presence: true

  def as_indexed_json(_options = {})
    as_json(only: %i[name])
  end
end
