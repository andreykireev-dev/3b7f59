require "test_helper"
require "authorization_helper"

class Api::ProspectImportsControllerTest < ActionDispatch::IntegrationTest
  # include Devise::Test::IntegrationHelpers
  include AuthorizationHelper


  setup do

    @user = {email: "test@test.com", password: "sample"}

    User.create @user
    host! 'localhost:3001'

    @auth_token = auth_tokens_for_user(@user)

    @valid_headers =     {
      "Authorization" => "Bearer #{@auth_token}",
      "Content-Type" => "application/json"
    }

  end

  test 'create action with uploading a excel should do import' do

    msg = {
      file: fixture_file_upload('files/valid_prospects_import_w-header_1.csv', 'text/csv', :binary), 
      email_index: "email test", 
      first_name_index: "fname est", 
      last_name_index: "lname test", 
      force: "ftest", 
      has_headers: "hed test"
    }

    post api_prospects_files_import_path, params: msg.to_json, headers: @valid_headers

    assert_response :success

    server_response = JSON.parse @response.body

    assert_equal "Ok", server_response["status"]

  end
end
