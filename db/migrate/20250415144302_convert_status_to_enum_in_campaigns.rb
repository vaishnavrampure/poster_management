class ConvertStatusToEnumInCampaigns < ActiveRecord::Migration[6.0]
  def up
    add_column :campaigns, :status_temp, :integer, default: 0

    Campaign.reset_column_information
    Campaign.find_each do |campaign|
      mapped_value = case campaign.status
        when "Pending" then 0
        when "Active" then 1
        when "Completed" then 2
        else 0
      end
      campaign.update_column(:status_temp, mapped_value)
    end

    remove_column :campaigns, :status
    rename_column :campaigns, :status_temp, :status
  end

  def down
    add_column :campaigns, :status_temp, :string

    Campaign.reset_column_information
    Campaign.find_each do |campaign|
      mapped_value = case campaign.status
        when 0 then "Pending"
        when 1 then "Active"
        when 2 then "Completed"
        else "Pending"
      end
      campaign.update_column(:status_temp, mapped_value)
    end

    remove_column :campaigns, :status
    rename_column :campaigns, :status_temp, :status
  end
end
