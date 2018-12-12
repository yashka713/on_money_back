class Category < ApplicationRecord
  TYPES = %w[charge profit].freeze

  enum type_of: TYPES

  belongs_to :user

  validates :name, length: { maximum: 25 }, presence: true
  validates :note, length: { maximum: 100 }, allow_nil: true
  validates :type_of, inclusion: { in: TYPES }, presence: true

  validate :type_not_changeable, on: :update
  validate :max_category_amount, on: :create

  scope :charges_categories, ->(user) { where(type_of: 'charge', user_id: user.id) }
  scope :profits_categories, ->(user) { where(type_of: 'profit', user_id: user.id) }

  private

  def type_not_changeable
    return unless type_of_changed?

    errors[:base] << I18n.t('category.errors.type_changed')
  end

  def max_category_amount
    return if limit_charges_not_reached? || limit_profits_not_reached?

    errors[:base] << I18n.t('category.errors.max_amount_riched')
  end

  def limit_charges_not_reached?
    type_of == 'charge' && self.class.charges_categories(user).length <= ENV['MAX_CATEGORY_AMOUNT'].to_i
  end

  def limit_profits_not_reached?
    type_of == 'profit' && self.class.profits_categories(user).length <= ENV['MAX_CATEGORY_AMOUNT'].to_i
  end
end
