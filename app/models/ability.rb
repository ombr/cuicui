class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Page
    can :manage, Site
    can :manage, Image
  end
end
