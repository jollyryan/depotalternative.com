class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      
      alias_action :edit, :update, :to => :modify
      
      can :read, Supplier
      can :create, Supplier if user
      can [:modify, :destroy], Supplier, :user_id => user.id
      can :manage, Favorite, :user_id => user.id
      can :read, Specialty, :message => "Admin access only."
    end
  end
end
