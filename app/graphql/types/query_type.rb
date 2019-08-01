module Types
  class QueryType < Types::BaseObject
    field :month_total, MonthTotalType, resolver: Resolvers::MonthTotalResolver, null: true do
      description 'Month total charge amount grouped by category'
      argument :date, String, required: false
      argument :account_ids, [String], required: false, prepare: ->(account_ids, _ctx) { account_ids.map(&:to_i) }
    end
  end
end
