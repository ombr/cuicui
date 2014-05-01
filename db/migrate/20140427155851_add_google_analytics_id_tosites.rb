class AddGoogleAnalyticsIdTosites < ActiveRecord::Migration
  def change
   add_column :sites, :google_analytics_id, :string
  end
end
