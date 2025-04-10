class AddClientCompanyIdToCampaigns < ActiveRecord::Migration[8.0]
  def change
    add_column :campaigns, :client_company_id, :integer
  end
end
