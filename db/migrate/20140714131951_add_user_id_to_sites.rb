class AddUserIdToSites < ActiveRecord::Migration
  def up
    add_column :sites, :user_id, :integer
    execute 'UPDATE sites SET user_id = (SELECT users.id FROM users LIMIT 1)'
  end
  def down
    remove_column :sites, :user_id
  end
end
