class AddImportReferenceToProspects < ActiveRecord::Migration[6.1]
  def change
    add_reference :prospects, :prospect_import, foreign_key: true
  end
end
