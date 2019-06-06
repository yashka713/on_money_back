RATES = {
  usd_to_uah: 10,
  uah_to_usd: 0.1,
  eur_to_uah: 15,
  uah_to_eur: 0.067,
  usd_to_eur: 0.67,
  eur_to_usd: 1.5
}.freeze

def transfer_params(date)
  from = Account.all.sample
  to = (Account.all - [from]).sample
  {
    date: date,
    amount: rand(1.0...99.9).round(2),
    from: from.id,
    to: to.id,
    rate: rate(from, to)
  }
end

def profit_params(date)
  from = Category.profit.sample
  to = Account.all.sample
  {
    date: date,
    amount: rand(1.0...99.9).round(2),
    from: from.id,
    to: to.id
  }
end

def charge_params(date)
  from = Account.all.sample
  to = Category.charge.sample
  {
    date: date,
    amount: rand(1.0...99.9).round(2),
    from: from.id,
    to: to.id
  }
end

def currencies_the_same?(from, to)
  from.currency == to.currency
end

def rate(from, to)
  return 1 if currencies_the_same?(from, to)

  RATES["#{from.currency.downcase}_to_#{to.currency.downcase}".to_sym]
end

def create_profit(date)
  transaction = Transaction.new(user: User.first, operation_type: :profit)
  profit_service = ProfitService.new(transaction, profit_params(date))

  profit_service.create
end

def create_charge(date)
  transaction = Transaction.new(user: User.first, operation_type: :charge)
  charge_service = ChargeService.new(transaction, charge_params(date))

  charge_service.create
end

def create_transfer(date)
  transaction = Transaction.new(user: User.first, operation_type: :transfer)
  transfer_service = TransferService.new(transaction, transfer_params(date))

  transfer_service.create
end

(1.month.ago.to_date..Date.today).map do |date|
  create_transfer(date)
  create_profit(date)
  create_charge(date)
end

puts 'Transaction successfully created'
