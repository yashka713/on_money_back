module Resolvers
  class MonthTotalChargesResolver < Resolvers::BaseResolver
    type [Types::MonthTotalChargesType], null: true

    def resolve(**args)
      current_month = transactions_month(args[:date])
      account_ids = args[:account_ids].map(&:to_i)

      monthly_grouped_charges = context[:current_user].transactions.monthly_grouped_charges(current_month, account_ids)

      {
        month: current_month.strftime('%B %Y'),
        data: Charts::MonthTotalService.call(monthly_grouped_charges)
      }
    end

    private

    def transactions_month(date)
      date.present? ? date.to_datetime : (context[:current_user].transactions.last.date || DateTime.now)
    end
  end
end
