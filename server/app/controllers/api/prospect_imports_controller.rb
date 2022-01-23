class Api::ProspectImportsController < ApplicationController
  def create

    prospect_import = @user.prospect_imports.new(
      original_filename: prospect_import_params[:file].original_filename,
      **prospect_import_params
    )

    prospect_import.save

    prospect_import.run_later

    render json: {
      job_id: prospect_import.id,
      status: prospect_import.status
    }
  end

  def show
    begin
      prospect_import = @user.prospect_imports.find params[:id]
    rescue ActiveRecord::RecordNotFound
      render :status => :not_found
      return
    end
    # debugger if prospect_import.completed?
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

end
