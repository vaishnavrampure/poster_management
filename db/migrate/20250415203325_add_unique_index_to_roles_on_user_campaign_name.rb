class AddUniqueIndexToRolesOnUserCampaignName < ActiveRecord::Migration[7.0]
  def change
    add_index :roles, [:user_id, :campaign_id, :name], unique: true
  end
end
