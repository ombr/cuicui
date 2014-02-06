class AddDefaultValueToDescriptionHtmlAttribute < ActiveRecord::Migration
  def up
    change_column :pages, :description_html, :text, default: ''
  end

  def down
    change_column :pages, :description_html, type: :text, default: nil
  end
end
