module Abilities
  class ChargeAbility
    include CanCan::Ability

    def initialize(user)
      can %i[show update destroy], Transaction do |transaction|
        transaction.user == user
      end
    end
  end
end
