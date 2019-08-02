module Resolvers
  class ProfitFromYearStartResolver < Resolvers::BaseResolver
    type [Types::ProfitFromYearStartType], null: true

    def resolve(**args)
      current_year = transactions_year(args[:year])

      year_grouped_profits = context[:current_user].transactions.year_grouped_profits(current_year)

      year_grouped_profits.group_by { |m| m.date.beginning_of_month }.each do |month, transactions|
        transactions.group_by { |m| m.accounts_currency }
      end

      {
        year: current_month.strftime('%B %Y'),
        data: Charts::MonthTotalService.call(year_grouped_profits)
      }
    end

    private

    def transactions_year(year)
      year.empty? ? DateTime.now : valid_date(year)
    end

    def valid_date(year)
      DateTime.strptime(year, '%Y')
    end
  end
end
