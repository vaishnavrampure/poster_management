class RemoveClientIdFromCampaigns < ActiveRecord::Migration[7.0]
  def change
    remove_column :campaigns, :client_id, :bigint
  end
end
