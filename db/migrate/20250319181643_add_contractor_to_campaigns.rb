class AddContractorToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_reference :campaigns, :contractor, foreign_key: { to_table: :users }

   
    reversible do |dir|
      dir.up do
        default_contractor_id = User.first&.id || 1
        execute "UPDATE campaigns SET contractor_id = #{default_contractor_id} WHERE contractor_id IS NULL"
      end
    end

   
    change_column_null :campaigns, :contractor_id, false
  end
end
