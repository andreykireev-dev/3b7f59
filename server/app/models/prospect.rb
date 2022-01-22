class Prospect < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :campaigns

  def self.import(**args)

    import_errors = []
# byebug
    begin
      
      data = CSV.readlines(args[:file])

      # get header row and remove it from the data array (https://apidock.com/ruby/Array/shift)
      headers = data.shift if args[:has_headers] 

      data.each_with_index do |row, idx|

        # create hash from headers and cells
        prospect_data = {
          email: row[args[:email_index]],
          first_name: row[args[:first_name_index]],
          last_name: row[args[:last_name_index]],
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

      rescue => exception
        # byebug
        error_message = %{Could not load the file. There was an error: #{exception} at }
      result = {imported: false, error_message: error_message}
    end
    
    return result
  end

end
