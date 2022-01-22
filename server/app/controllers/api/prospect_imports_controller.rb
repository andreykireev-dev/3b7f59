class Api::ProspectImportsController < ApplicationController
  def create
    result = @user.prospects.import prospect_import_params
    msg = { 
      :status => "Ok", 
      :errors => false, 
      result: result
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
