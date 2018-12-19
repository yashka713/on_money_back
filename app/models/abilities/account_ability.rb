module Abilities
  class AccountAbility
    include CanCan::Ability

    def initialize(user)
      can %i[show update destroy], Account do |account|
        account.user_id == user.id
      end
    end
  end
end
