class Api::ProspectImportsController < ApplicationController
  before_action :validate_params, only: [:create]

  def create

    prospect_import = @user.prospect_imports.new(
      original_filename: prospect_import_params[:file]&.original_filename,
      **prospect_import_params
    )


    if prospect_import.save

      prospect_import.run_later

      render json: {
        job_id: prospect_import.id,
        status: prospect_import.status
      }
    else 
      render json: {
        status: "error",
        messages: prospect_import.errors.full_messages
      }
    end
  end

  def show
    
    begin
      prospect_import = @user.prospect_imports.find params[:id]
    rescue ActiveRecord::RecordNotFound
      render :status => :not_found
      return
    end

    render json: {
      total: prospect_import.total_rows,
      done: prospect_import.done_rows
    }


  end


  private


  def prospect_import_params
    params.permit(
      :email_index, 
      :first_name_index, 
      :last_name_index, 
      :force, 
      :has_headers, 
      :file
    )
  end

  def validate_params
    errors = []

    prospect_import_params.to_enum.each do |field, value|

      case ProspectImport.columns_hash[field]&.type
      when :integer
        errors << "#{field.to_s.titleize} must be an Integer" unless is_integer?(value)
      when :boolean
        errors << "#{field.to_s.titleize} must be a Boolean (e.g. True, False, 0 or 1)" unless is_boolean?(value)
      end

      if field == "file"
        file = prospect_import_params[field]
        if file.class != ActionDispatch::Http::UploadedFile || file.content_type != "text/csv"
          errors << "#{field.to_s.titleize} must be a CSV attachment"
        end
      end

    end
    if errors.any?
        render json: {
        status: "error",
        messages: errors
      }
      return false
    else
      return true
    end
  end

  def is_integer?(value)
    value.to_s == value.to_i.to_s
  end

  def is_boolean?(value)
    value.to_s.downcase.in? %w(true false 0 1)
  end

end
