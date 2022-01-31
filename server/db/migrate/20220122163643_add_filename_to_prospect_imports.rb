class AddFilenameToProspectImports < ActiveRecord::Migration[6.1]
  def change
    add_column :prospect_imports, :original_filename, :string
  end
end
