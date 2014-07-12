class AddOriginalToImages < ActiveRecord::Migration
  def change
    add_column :images, :original, :text
  end
end
