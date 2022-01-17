class CreateProspects < ActiveRecord::Migration[6.1]
  def change
    create_table :prospects do |t|
      t.string :email
      t.text :first_name
      t.text :last_name

      t.timestamps
    end
  end
end
