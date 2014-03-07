class AddLanguageToSites < ActiveRecord::Migration
  def change
    add_column :sites, :language, :string, default: :en
  end
end
