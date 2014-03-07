class AddCssContentToImages < ActiveRecord::Migration
  def change
    add_column :images, :content_css, :text, default: 'bottom: 22.02204265611258%;top: auto;right: 13.927145245170877%;left: auto;'
  end
end
