class AddSnapshotToImages < ActiveRecord::Migration
  def change
    add_column :images, :snapshot, :text
  end
end
