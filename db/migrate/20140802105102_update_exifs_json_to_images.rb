# UpdateExifsJsonToImages
class UpdateExifsJsonToImages < ActiveRecord::Migration
  def up
    remove_column :images, :exifs
    add_column :images, :exifs, :json
  end
  def down
    remove_column :images, :exifs
    add_column :images, :exifs, :text
  end
end
