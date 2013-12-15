class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :page_id
      t.string :image
    end
  end
end
