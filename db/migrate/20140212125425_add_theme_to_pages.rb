class AddThemeToPages < ActiveRecord::Migration
  def change
    add_column :pages, :theme, :string, default: 'light'
  end
end
