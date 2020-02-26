module Abilities
  class ReceiptAbility
    include CanCan::Ability

    def initialize(user)
      can %i[destroy], Receipt do |receipt|
        receipt.user == user
      end
    end
  end
end
