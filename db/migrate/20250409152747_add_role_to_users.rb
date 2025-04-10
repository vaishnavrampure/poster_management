# db/migrate/xxxxxx_add_role_to_users.rb
class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :role, foreign_key: true, null: true
  end
end
