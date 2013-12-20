class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, Page
      can :manage, Site
      can :manage, Image
    else
      can :read, Page
      can :read, Site
      can :read, Image
    end
  end
end
