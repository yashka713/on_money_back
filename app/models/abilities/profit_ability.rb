module Abilities
  class ProfitAbility
    include CanCan::Ability

    def initialize(user)
      can %i[show update destroy], Transaction do |transaction|
        transaction.user == user
      end
    end
  end
end
