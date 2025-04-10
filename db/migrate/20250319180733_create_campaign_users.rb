class CreateCampaignUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_users do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
