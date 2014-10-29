# AddFontBodyToSites
class AddFontBodyToSites < ActiveRecord::Migration
  def change
    add_column :sites, :font_body, :string
  end
end
