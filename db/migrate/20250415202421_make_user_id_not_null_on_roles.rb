class MakeUserIdNotNullOnRoles < ActiveRecord::Migration[7.0]
  def change
    change_column_null :roles, :user_id, false
  end
end
