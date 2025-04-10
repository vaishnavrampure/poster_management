class ChangeRoleToStringInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :role, :string, default: "client"  # Set default role to "client"
  end
end
