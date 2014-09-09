class AddFocusToImages < ActiveRecord::Migration
  def change
    add_column :images, :focusx, :float
    add_column :images, :focusy, :float
  end
end
