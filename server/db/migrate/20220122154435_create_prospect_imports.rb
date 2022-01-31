class CreateProspectImports < ActiveRecord::Migration[6.1]
  def change
    create_table :prospect_imports do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
