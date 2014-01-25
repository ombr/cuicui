class AddMetasToSites < ActiveRecord::Migration
  def change
    add_column :sites, :metas, :text
  end
end
