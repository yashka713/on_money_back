module Types
  class QueryType < Types::BaseObject
    field :month_total_charges, MonthTotalChargesType,
          resolver: Resolvers::MonthTotalChargesResolver, null: true do
      description 'Month total charge amount grouped by category'
      argument :date, String, required: false
      argument :account_ids, [String], required: false, prepare: ->(account_ids, _ctx) { account_ids.map(&:to_i) }
    end

    field :profit_from_year_start, ProfitFromYearStartType,
          resolver: Resolvers::ProfitFromYearStartResolver, null: true do
      description 'Profit from year start by each currency'
      argument :year, String, required: false
    end
  end
end
