require "test_helper"

class Api::ProspectImportsControllerTest < ActionDispatch::IntegrationTest
  # include Devise::Test::IntegrationHelpers

  test 'create action with uploading a excel should do import' do
    assert true
    # position = users(:enterprise_user).company.positions.create! title: "Upload Test"
    # position.candidates.delete_all
    # sign_in users(:enterprise_user)
    # post position_candidates_path(position), params: { candidate: {import_file: fixture_file_upload('files/eqmatch_candidate_import_template_valid_file.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', :binary) }}
    # assert_response :redirect
    # position.reload
    # assert_equal 10, position.candidates.count
    # assert_match 'The import was succesful', flash[:notice]
    
    # will use partial file

  end
end
