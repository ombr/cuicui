class AddCssToSite < ActiveRecord::Migration
  def change
    add_column :sites, :css, :text
  end
end
