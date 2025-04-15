class ChangeStatusToStringInCampaigns < ActiveRecord::Migration[6.0]
  def change
    change_column :campaigns, :status, :string
  end
end
