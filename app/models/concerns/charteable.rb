module Charteable
  extend ActiveSupport::Concern

  included do
    scope :monthly_grouped_charges, (lambda do |date, account_ids|
      charges
        .charges_from_accounts(account_ids)
        .created_between(date.beginning_of_month, date.end_of_month)
        .joins('JOIN categories ON transactions.profitable_id = categories.id')
        .group(['categories.name', 'accounts.currency'])
        .sum(:from_amount)
    end)

    scope :year_grouped_profits, (lambda do |year|
      select('transactions.from_amount', 'transactions.date', 'accounts.currency AS accounts_currency')
        .profits
        .created_between(year.beginning_of_year, year.end_of_year)
        .joins('JOIN accounts ON transactions.profitable_id = accounts.id')
        # .group(['accounts.currency', 'transactions.date'])
        # .sum(:from_amount)
    end)
  end
end
