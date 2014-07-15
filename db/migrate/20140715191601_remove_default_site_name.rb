# RemoveDefaultSiteName
class RemoveDefaultSiteName < ActiveRecord::Migration
  def change
    change_column_default :sites, :title, nil
  end
end
