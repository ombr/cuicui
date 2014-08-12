class AddGeometriesToImages < ActiveRecord::Migration
  def change
    add_column :images, :geometries, :json
  end
end
