class AddGooglePlusIdToSites < ActiveRecord::Migration
  def change
    add_column :sites, :google_plus_id, :string
  end
end
