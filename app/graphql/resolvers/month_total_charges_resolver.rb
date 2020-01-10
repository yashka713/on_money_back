module Resolvers
  class MonthTotalChargesResolver < Resolvers::BaseResolver
    type [Types::MonthTotalChargesType], null: true

    def resolve(**args)
      current_month = transactions_month(args[:date])
      account_ids = args[:account_ids].map(&:to_i)
      current_user = context[:current_user]

      Charts::MonthTotalChargesService.call(current_user, current_month, account_ids)
    end

    private

    def transactions_month(date)
      date.present? ? date.to_datetime : (context[:current_user].transactions.last.date || DateTime.now)
    end
  end
end
