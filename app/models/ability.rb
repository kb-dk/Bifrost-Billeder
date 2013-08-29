class Ability
  include CanCan::Ability
  include Hydra::Ability
  include Hydra::AccessControlsEnforcement


  def initialize(user)
    super(user)
    @user = user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.depositor?
      can :read, :all
    else
      can :discover, :all
    end
  end
end

