class AddStatusToClientCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :client_companies, :status, :string
  end
end
