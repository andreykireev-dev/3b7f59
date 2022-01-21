class Api::ProspectImportsController < ApplicationController
  def create
    respond_to do |format|
      msg = { 
        :status => "ok", 
        :message => "Success!", 
        :html => "<b>...</b>",  
        **prospect_import_params
      }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end

  def prospect_import_params
    params.permit(
      :file, 
      :email_index, 
      :first_name_index, 
      :last_name_index, 
      :force, 
      :has_headers
    )
  end

end
