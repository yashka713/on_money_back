module Abilities
  class TransactionAbility
    include CanCan::Ability

    def initialize(user)
      can %i[destroy_receipt], Transaction do |transaction|
        transaction.user == user
      end
    end
  end
end
