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
      # "Content-Type" => "application/json"
      "Content-Type"=> "multipart/form-data"
    }

  end

  test 'create action with uploading a csv should do import' do

    msg = {
      file: fixture_file_upload('valid_prospects_import_w-header_1.csv', 'text/csv', :binary), 
      email_index: "email test", 
      first_name_index: "fname est", 
      last_name_index: "lname test", 
      force: true, 
      has_headers: false
    }

    post api_prospects_files_import_path, params: msg, headers: @valid_headers

    assert_response :success

    server_response = JSON.parse @response.body

    assert_equal "Ok", server_response["status"]
    assert_equal false, server_response["errors"]
    assert_equal true, server_response["imported"]

  end

end
