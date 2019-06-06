CURRENCIES = %w[USD EUR UAH].freeze

ACCOUNT_NAMES = %w[
  Credit\ card\ #1
  Credit\ card\ #2
  entity
].freeze

def cash_wallet_name(currency)
  "#{currency} CASH"
end

def random_amount
  rand(500.0...10_000.9).round(2)
end

CURRENCIES.map do |name|
  Account.create!(user_id: 1, balance: random_amount, currency: name, status: 0, name: cash_wallet_name(name))
end

ACCOUNT_NAMES.map do |name|
  Account.create!(user_id: 1, balance: random_amount, currency: CURRENCIES.sample, status: 0, name: name)
end

puts 'Accounts successfully created'
