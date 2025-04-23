class RemoveRoleIdFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :role_id, :integer
  end
end
