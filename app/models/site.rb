class Site < ActiveRecord::Base
  has_many :pages, -> { order('position') }

  class << self
    def first
      super || Site.create!
    end
  end
end
