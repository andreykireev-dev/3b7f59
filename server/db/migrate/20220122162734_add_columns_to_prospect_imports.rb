class AddColumnsToProspectImports < ActiveRecord::Migration[6.1]
  def change
    add_column :prospect_imports, :email_index, :integer
    add_column :prospect_imports, :first_name_index, :integer
    add_column :prospect_imports, :last_name_index, :integer
    add_column :prospect_imports, :force, :boolean 
    add_column :prospect_imports, :has_headers, :boolean 
  end
end
