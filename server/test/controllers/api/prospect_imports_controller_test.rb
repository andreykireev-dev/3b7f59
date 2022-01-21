require "test_helper"

class Api::ProspectImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_prospect_imports_create_url
    assert_response :success
  end
end
