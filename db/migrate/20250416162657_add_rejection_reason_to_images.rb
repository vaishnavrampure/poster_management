class AddRejectionReasonToImages < ActiveRecord::Migration[8.0]
  def change
    add_column :images, :rejection_reason, :string
  end
end
