class Ability
  include CanCan::Ability

  def initialize(user)
    merge Abilities::AccountAbility.new(user)
    merge Abilities::CategoryAbility.new(user)
    merge Abilities::ProfitAbility.new(user)
    merge Abilities::TransferAbility.new(user)
  end
end
