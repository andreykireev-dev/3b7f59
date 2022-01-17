class AddUserRefToProspects < ActiveRecord::Migration[6.1]
  def change
    add_reference :prospects, :user, null: false, foreign_key: true
  end
end
