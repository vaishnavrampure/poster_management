class CreateClientCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :client_companies do |t|
      t.string :name

      t.timestamps
    end
  end
end
