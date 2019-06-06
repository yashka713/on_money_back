PROFIT_CATEGORY_NAMES = %w[
  Salary
  Refunds
  Loans
  Presents
  Side\ job
  Savings
].freeze

CHARGE_CATEGORY_NAMES = %w[
  Products
  Transit
  Rest
  Commissions
  House\ rent
  Lunch
  Mom
  Sport
  Technical
  Education
  Trips
  Health
  Cloth
].freeze

PROFIT_CATEGORY_NAMES.map { |name| Category.create!(user_id: 1, type_of: 1, status: 0, name: name) }

CHARGE_CATEGORY_NAMES.map { |name| Category.create!(user_id: 1, type_of: 0, status: 0, name: name) }

puts 'Categories successfully added'
