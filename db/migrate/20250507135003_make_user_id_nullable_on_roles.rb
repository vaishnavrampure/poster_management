class MakeUserIdNullableOnRoles < ActiveRecord::Migration[7.0] # or [6.1]/[8.0] based on your version
  def change
    change_column_null :roles, :user_id, true
  end
end

