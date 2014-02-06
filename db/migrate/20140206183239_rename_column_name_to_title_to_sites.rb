class RenameColumnNameToTitleToSites < ActiveRecord::Migration
  def change
    rename_column :sites, :name, :title
  end
end
