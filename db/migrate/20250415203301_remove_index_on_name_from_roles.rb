class RemoveIndexOnNameFromRoles < ActiveRecord::Migration[7.0]
  def change
    remove_index :roles, :name
  end
end
