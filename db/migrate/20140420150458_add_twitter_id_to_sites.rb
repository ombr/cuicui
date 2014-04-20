# AddTwitterIdToSites
class AddTwitterIdToSites < ActiveRecord::Migration
  def change
    add_column :sites, :twitter_id, :string
  end
end
