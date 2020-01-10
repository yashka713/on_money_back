module Resolvers
  class ProfitFromYearStartResolver < Resolvers::BaseResolver
    type [Types::ProfitFromYearStartType], null: true

    def resolve(**args)
      current_user = context[:current_user]

      current_year = args[:year]

      Charts::ProfitFromYearStartService.call(current_user, current_year)
    end
  end
end
