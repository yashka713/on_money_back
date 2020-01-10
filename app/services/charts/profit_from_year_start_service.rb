module Charts
  module ProfitFromYearStartService
    extend self

    def call(current_user, year)
      current_year = transactions_year(year)

      profit_by_month = current_user.transactions
                            .year_grouped_profits(current_year)
                            .map { |transaction_summary| formatize(transaction_summary)}
                            .group_by{|summary| summary[:currency]}

      {
          year: current_year.strftime('%Y'),
          data: profit_by_month
      }
    end

    private

    def formatize(transaction_summary)
      {
          month: I18n.t('date.month_names')[transaction_summary.tr_date.month],
          currency: transaction_summary.accounts_currency,
          amount: transaction_summary.sum
      }
    end

    def transactions_year(year)
      year.empty? ? DateTime.now.year.to_s : DateTime.strptime(year, '%Y')
    end
  end
end
