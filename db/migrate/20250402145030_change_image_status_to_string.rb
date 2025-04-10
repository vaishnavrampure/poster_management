class ChangeImageStatusToString < ActiveRecord::Migration[7.0]
  def change
    change_column :images, :status, :string
  end
end
