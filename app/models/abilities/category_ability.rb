module Abilities
  class CategoryAbility
    include CanCan::Ability

    def initialize(user)
      can %i[show update destroy], Category do |category|
        category.user_id == user.id
      end
    end
  end
end
