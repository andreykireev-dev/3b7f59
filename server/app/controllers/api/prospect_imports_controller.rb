class Api::ProspectImportsController < ApplicationController
  def create
    msg = { 
      :status => "Ok", 
      :message => "Success!", 
      :html => "<b>...</b>",  
      **prospect_import_params
    }
    render json: msg
  end

  def prospect_import_params
    params.permit(
      :email_index, 
      :first_name_index, 
      :last_name_index, 
      :force, 
      :has_headers,
      file: {}
    )
  end

end
