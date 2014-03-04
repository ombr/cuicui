class AddContentToImages < ActiveRecord::Migration
  def change
    add_column :images, :content, :text, default: ''
    execute 'UPDATE images SET content = pages.description FROM pages WHERE images.page_id = pages.id AND images.position = 1'
  end
end
