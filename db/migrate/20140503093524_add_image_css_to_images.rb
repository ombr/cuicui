class AddImageCssToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_css, :text
  end
end
