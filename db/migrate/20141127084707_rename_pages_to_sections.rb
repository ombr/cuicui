class RenamePagesToSections < ActiveRecord::Migration
  def up
    rename_table :pages, :sections
    rename_column :images, :page_id, :section_id
  end

  def down
    rename_table :sections, :pages
    rename_column :images, :section_id, :page_id
  end
end
