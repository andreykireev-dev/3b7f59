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
      email_index: 0, 
      first_name_index: 1, 
      last_name_index: 2, 
      force: true, 
      has_headers: true
    }

    post api_prospects_files_import_path, params: msg, headers: @valid_headers

    assert_response :success

    server_response = JSON.parse @response.body

    assert_equal "queued", server_response["status"]
    assert server_response["job_id"].present? 

  end

  test 'checking the job in progress should get expected result' do
    msg = {
      file: fixture_file_upload('valid_prospects_import_w-header_2.csv', 'text/csv', :binary), 
      email_index: 0, 
      first_name_index: 1, 
      last_name_index: 2, 
      force: true, 
      has_headers: true
    }

    post api_prospects_files_import_path, params: msg, headers: @valid_headers
    
    server_response = JSON.parse @response.body
    job_id = server_response["job_id"]

    get "/api/prospects_files/#{job_id}/progress", headers: @valid_headers

    assert_response :success
    
    # Response Body: { 
    #   total: number, 
    #   done: number 
    # }

    server_response = JSON.parse @response.body

    assert_equal 35, server_response["total"]
    assert_equal 0, server_response["done"]
  end

  test 'checking the completed job should get expected result' do
    msg = {
      file: fixture_file_upload('valid_prospects_import_w-header_2.csv', 'text/csv', :binary), 
      email_index: 0, 
      first_name_index: 1, 
      last_name_index: 2, 
      force: true, 
      has_headers: true
    }

    post api_prospects_files_import_path, params: msg, headers: @valid_headers
    
    server_response = JSON.parse @response.body
    job_id = server_response["job_id"]
    
    #completing job
    prospect_import = ProspectImport.find(job_id)

    assert prospect_import.queued?
    
    prospect_import.run
    assert prospect_import.completed?
    
    get "/api/prospects_files/#{job_id}/progress", headers: @valid_headers

    assert_response :success
    
    # Response Body: { 
    #   total: number, 
    #   done: number 
    # }

    server_response = JSON.parse @response.body
    
    assert_equal 35, server_response["total"]
    assert_equal 35, server_response["done"]

  end

  test "get to show with wrong id should give 404" do 
    get "/api/prospects_files/666/progress", headers: @valid_headers
    assert_response :not_found
  end

  test "unauthorized post should give 403" do
    msg = {
      file: fixture_file_upload('valid_prospects_import_w-header_2.csv', 'text/csv', :binary), 
      email_index: 0, 
      first_name_index: 1, 
      last_name_index: 2, 
      force: true, 
      has_headers: true
    }

    post api_prospects_files_import_path, params: msg
    assert_response :unauthorized
  end

  test "unauthorized get should give 403" do
    get "/api/prospects_files/666/progress"
    assert_response :unauthorized
  end

  test "post with missing file should not be successful" do
    msg = {
      # file: fixture_file_upload('valid_prospects_import_w-header_2.csv', 'text/csv', :binary), 
      email_index: 0, 
      first_name_index: 1, 
      last_name_index: 2, 
      force: true, 
      has_headers: true
    }

    post api_prospects_files_import_path, params: msg, headers: @valid_headers

    assert_response :success

    server_response = JSON.parse @response.body

    assert_equal "error", server_response["status"]
    refute server_response["job_id"].present? 

  end

  
  test "post with missing email index should not be successful" do
    msg = {
      file: fixture_file_upload('valid_prospects_import_w-header_2.csv', 'text/csv', :binary), 
      # email_index: 0, 
      first_name_index: 1, 
      last_name_index: 2, 
      force: true, 
      has_headers: true
    }

    post api_prospects_files_import_path, params: msg, headers: @valid_headers

    assert_response :success

    server_response = JSON.parse @response.body

    assert_equal "error", server_response["status"]
    refute server_response["job_id"].present? 

  end
  
  test "post with wrong email index type should not be successful" do
    msg = {
      file: fixture_file_upload('valid_prospects_import_w-header_2.csv', 'text/csv', :binary), 
      email_index: "zero", 
      first_name_index: 1, 
      last_name_index: 2, 
      force: true, 
      has_headers: true
    }

    post api_prospects_files_import_path, params: msg, headers: @valid_headers

    assert_response :success

    server_response = JSON.parse @response.body

    assert_equal "error", server_response["status"]
    assert_equal "Email Index must be an Integer", server_response["messages"].first
    refute server_response["job_id"].present? 

  end
  
  test "post with wrong file type should not be successful" do
    msg = {
      file: "some file", 
      email_index: 0, 
      first_name_index: 1, 
      last_name_index: 2, 
      force: true, 
      has_headers: true
    }

    post api_prospects_files_import_path, params: msg, headers: @valid_headers

    assert_response :success

    server_response = JSON.parse @response.body

    assert_equal "error", server_response["status"]
    assert_equal "File must be a CSV attachment", server_response["messages"].first
    refute server_response["job_id"].present? 

  end


end
