class Api::ProspectImportsController < ApplicationController
  def create
    byebug if prospect_import_params.empty?
    result = @user.prospects.import(
      file: prospect_import_params[:file],
      email_index: prospect_import_params[:email_index],
      first_name_index: prospect_import_params[:first_name_index],
      last_name_index: prospect_import_params[:last_name_index],
      force: prospect_import_params[:force],
      has_headers: prospect_import_params[:has_headers]
    )
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
      :file
    )
  end

end
