# AddFontHeaderToSites
class AddFontHeaderToSites < ActiveRecord::Migration
  def change
    add_column :sites, :font_header, :string
  end
end
