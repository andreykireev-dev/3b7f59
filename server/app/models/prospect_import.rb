class ProspectImport < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  enum status: {
    uploading: 0, 
    processing: 1, 
    completed: 2, 
    purged: 3
  }, _default: 0

  def run
    result = Hash.new
    import_errors = Array.new
    imported_rows = 0
    

    if file.open{|f| f.count} > 1000000
      result = result.merge(
        imported: false, 
        imported_rows: imported_rows,
        errors: true, 
        error_messages: "CSV row size exceeded. Only files smaller than 1m rows are acceptable"
      )
      return result
    end
  
    if file.open{|f| f.size} > (200 * 1024 * 1024)
      result = result.merge(
        imported: false, 
        imported_rows: imported_rows,
        errors: true, 
        error_messages: "CSV file size exceeded. Only files smaller than 200MB are acceptable"
      )
      return result
    end
    file.open do |f|
      CSV.open(f, skip_blanks: true, headers: has_headers) do |csv|
        csv.each do |row|
          imported_rows = csv.lineno
          imported_rows -= 1 if has_headers
  
          # create hash from headers and cells
          prospect_data = {
            email: row[email_index],
            first_name: row[first_name_index],
            last_name: row[last_name_index],
          }
  
          if user.prospects.exists? email: prospect_data[:email]
            existing_prospect = user.prospects.find_by email: prospect_data[:email]
            existing_prospect.update prospect_data
          else
            new_prospect = user.prospects.new prospect_data
            if new_prospect.valid?
              new_prospect.save
            else 
              import_errors << "Row #{imported_rows}: #{new_prospect.errors.full_messages.join(' ')}"
            end
  
          end
        end
      end
      result = result.merge imported: true, errors: false, imported_rows: imported_rows
      result = result.merge error_messages: import_errors if import_errors.any?
      
      return result
    end
  end
end
