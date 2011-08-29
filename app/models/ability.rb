class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, Supplier
      can :udpate, Supplier, :user_id => user.id, :message => "You can only update your own listing."
      can :read, Specialty, :message => "Admin access only."
      can :read, City, :message => "Admin access only."
    end
  end
end
