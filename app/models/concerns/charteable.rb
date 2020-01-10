module Charteable
  extend ActiveSupport::Concern

  PROFIT_COLUMNS = %q{SUM(transactions.from_amount),
                      date_trunc('month', transactions.date) AS tr_date,
                      accounts.currency AS accounts_currency}

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
      select(PROFIT_COLUMNS)
        .profits
        .created_between(year.beginning_of_year, year.end_of_year)
        .joins('JOIN accounts ON transactions.profitable_id = accounts.id')
        .group(['accounts_currency', 'tr_date'])
        .order('tr_date')
    end)
  end
end
