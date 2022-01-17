class AddUserRefToCampaigns < ActiveRecord::Migration[6.1]
  def change
    add_reference :campaigns, :user, null: false, foreign_key: true
  end
end
