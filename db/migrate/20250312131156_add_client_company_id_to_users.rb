class AddClientCompanyIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :client_company_id, :integer
  end
end
