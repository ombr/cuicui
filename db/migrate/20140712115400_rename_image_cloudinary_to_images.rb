class RenameImageCloudinaryToImages < ActiveRecord::Migration
  def change
    rename_column :images, :image, :cloudinary
  end
end
