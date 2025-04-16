class AddUserIdToRoles < ActiveRecord::Migration[8.0]
  def change
    add_reference :roles, :user, foreign_key: true
  end
end
