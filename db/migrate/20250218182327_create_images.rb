class CreateImages < ActiveRecord::Migration[8.0]
  def change
    create_table :images do |t|
      t.string :file
      t.integer :status
      t.references :campaign, null: false, foreign_key: true
      t.references :contractor, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
