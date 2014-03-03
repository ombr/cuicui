class AddFullToImages < ActiveRecord::Migration
  def change
    add_column :images, :full, :boolean, default: false
  end
end
