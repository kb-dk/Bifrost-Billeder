# -*- encoding : utf-8 -*-
class Ability
  include Hydra::Ability
  include Hydra::PolicyAwareAbility

  def initialize(user)
    super(user)
    @user = user ||= User.new # guest user (not logged in)
    if user.new_record?
      can :read, :all
    else
      can :manage, :all
    end
  end
end

