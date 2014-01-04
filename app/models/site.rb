class Site < ActiveRecord::Base
  has_many :pages, -> { order('position DESC') }

  class << self
    def first
      super || Site.create!
    end
  end
end
