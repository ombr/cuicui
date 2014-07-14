# Ability
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Site
      can :update, Site, user: user
      can [:update, :create, :destroy], Page, user: user
      can [:update, :destroy], Image, user: user
      can :create, Image, user: user
    end
    can :read, Page
    can :next, Page
    can :read, Site
    can :read, Image
  end
end
