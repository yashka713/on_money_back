class Category < ApplicationRecord
  include Searchable

  TYPES = %w[charge profit].freeze
  STATUSES = %w[active hidden].freeze

  enum type_of: TYPES
  enum status: STATUSES

  belongs_to :user

  validates :name, length: { maximum: 25 }, presence: true
  validates :note, length: { maximum: 100 }, allow_nil: true

  validates :type_of, inclusion: { in: TYPES }, presence: true
  validates :status, inclusion: { in: STATUSES }, presence: true

  validate :type_not_changeable, on: :update

  scope :charges_categories, ->(user) { where(type_of: 'charge', user_id: user.id, status: 'active') }
  scope :profits_categories, ->(user) { where(type_of: 'profit', user_id: user.id, status: 'active') }

  def destroy(params)
    CategoryDestroyerService.new(self, params).destroy
  end

  # stub for elastic indexes
  def currency; end

  def as_indexed_json(_options = {})
    as_json(only: %i[name currency])
  end

  private

  def type_not_changeable
    return unless type_of_changed?

    errors[:base] << I18n.t('category.errors.type_changed')
  end
end
