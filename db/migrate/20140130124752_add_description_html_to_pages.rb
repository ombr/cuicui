class AddDescriptionHtmlToPages < ActiveRecord::Migration
  def change
    add_column :pages, :description_html, :text
  end
end
