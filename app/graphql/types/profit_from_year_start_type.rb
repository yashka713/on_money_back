module Types
  class ProfitFromYearStartType < Types::BaseObject
    field :year, String, null: false
    field :data, GraphQL::Types::JSON, null: false
  end
end
