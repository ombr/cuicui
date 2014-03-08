class RenameDescriptionToLegendToImages < ActiveRecord::Migration
  def change
    rename_column :images, :description, :legend
  end
end
