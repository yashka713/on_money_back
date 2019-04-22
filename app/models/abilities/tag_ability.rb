module Abilities
  class TagAbility
    include CanCan::Ability

    def initialize(user)
      can %i[show update destroy], Tag do |tag|
        tag.user == user
      end
    end
  end
end
