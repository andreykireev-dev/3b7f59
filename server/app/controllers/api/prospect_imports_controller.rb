class Api::ProspectImportsController < ApplicationController
  def create

    prospect_import = @user.prospect_imports.new(
      original_filename: prospect_import_params[:file].original_filename,
      **prospect_import_params
    )

    prospect_import.save

    result = prospect_import.run
    msg = { 
      :status => "Ok", 
    }
    render json: msg.merge(result)
  end

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
