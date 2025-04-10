class AddDefaultRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :role, "client"  # Set the default role as 'client'
  end
end
