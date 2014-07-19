# Ability
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Site
      can :update, Site, user: user
      can [:update, :create, :destroy, :preview], Page, user: user
      can [:update, :destroy, :add], Image, user: user
      can :create, Image do |image|
        image.page.user == user
      end
    end
    global_right(user)
  end

  private

  def global_right(_user)
    can [:read, :next, :first], Page
    can [:read, :robots, :sitemap], Site
    can :read, Image
  end
end
