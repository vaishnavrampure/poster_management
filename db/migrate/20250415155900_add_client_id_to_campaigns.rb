class AddClientIdToCampaigns < ActiveRecord::Migration[8.0]
  def change
    add_column :campaigns, :client_id, :integer
  end
end
