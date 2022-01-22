class Prospect < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :campaigns

  def self.import(
    file:, 
    email_index: ,
    first_name_index: , 
    last_name_index: , 
    force: ,
    has_headers: 
  )

    import_errors = []
      CSV.foreach(file, skip_blanks: true, headers: has_headers) do |row|

        # create hash from headers and cells
        prospect_data = {
          email: row[email_index],
          first_name: row[first_name_index],
          last_name: row[last_name_index],
        }
        
        if self.exists? email: prospect_data[:email]
          existing_prospect = self.find_by email: prospect_data[:email]
          existing_prospect.update prospect_data
        else
          new_prospect = self.new prospect_data
          if new_prospect.valid?
            new_prospect.save
          else 
            import_errors << "Row #{idx+1}: #{new_prospect.errors.full_messages.join(' ')}"
          end

        end
      end

      if import_errors.any?
        result = {imported: true, errors: true, error_messages: import_errors}
      else  
        result = {imported: true, errors: false}
      end
    
    return result
  end

end
