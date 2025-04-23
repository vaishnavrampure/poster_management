class ChangeContractorIdNullableInCampaigns < ActiveRecord::Migration[6.1]
  def change
    change_column_null :campaigns, :contractor_id, true
  end
end
