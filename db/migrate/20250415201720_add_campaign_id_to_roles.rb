class AddCampaignIdToRoles < ActiveRecord::Migration[8.0]
  def change
    add_reference :roles, :campaign, foreign_key: true
  end
end
