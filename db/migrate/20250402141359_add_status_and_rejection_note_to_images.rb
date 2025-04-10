class AddStatusAndRejectionNoteToImages < ActiveRecord::Migration[7.0]
  def change
    # Skip this if the column already exists
    unless column_exists?(:images, :status)
      add_column :images, :status, :string, default: "pending"
    end

    unless column_exists?(:images, :rejection_note)
      add_column :images, :rejection_note, :text
    end
  end
end
