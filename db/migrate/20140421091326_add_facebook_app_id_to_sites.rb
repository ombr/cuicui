class AddFacebookAppIdToSites < ActiveRecord::Migration
  def change
    add_column :sites, :facebook_app_id, :string
  end
end
