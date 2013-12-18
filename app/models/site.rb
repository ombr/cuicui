class Site < ActiveRecord::Base
  has_many :pages, -> { order('position DESC') }
end
