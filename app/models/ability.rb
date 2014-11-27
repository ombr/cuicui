# Ability
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Site
      can [:update, :destroy], Site, user: user
      can [:update, :create, :destroy, :preview], Section, user: user
      can [:update, :destroy, :add], Image, user: user
      can :create, Image do |image|
        image.section.user == user
      end
    end
    global_right(user)
  end

  private

  def global_right(_user)
    can [:read, :next, :first], Section
    can [:read, :robots, :sitemap], Site
    can :read, Image
  end
end
