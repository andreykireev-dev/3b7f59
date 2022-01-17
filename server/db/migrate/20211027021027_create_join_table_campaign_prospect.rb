class CreateJoinTableCampaignProspect < ActiveRecord::Migration[6.1]
  def change
    create_join_table :campaigns, :prospects do |t|
      t.index [:campaign_id, :prospect_id]
      t.index [:prospect_id, :campaign_id]
    end
  end
end
