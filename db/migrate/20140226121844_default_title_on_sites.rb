class DefaultTitleOnSites < ActiveRecord::Migration
  def change
    change_column_default(:sites, :title, 'My Portfoli')
  end
end
