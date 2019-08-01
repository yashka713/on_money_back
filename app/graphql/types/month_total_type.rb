module Types
  class MonthTotalType < Types::BaseObject
    field :month, String, null: false
    field :data, GraphQL::Types::JSON, null: false
  end
end
