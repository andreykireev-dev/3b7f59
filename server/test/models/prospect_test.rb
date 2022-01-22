require "test_helper"

class ProspectTest < ActiveSupport::TestCase

  setup do
    @user = User.create email: "test@test.com", password: "sample"
  end


  test 'import method should import prospects from file' do
    
    test_file_path = "#{fixture_path}files/valid_prospects_import_w-header_1.csv"
    file = File.new(test_file_path)

    result = @user.prospects.import(
      file: file,
      email_index: 0,
      first_name_index: 1,
      last_name_index: 2,
      force: true,
      has_headers: true
      )
    assert result[:imported]
    refute result[:errors]
    @user.reload

    assert_equal 35, @user.prospects.count

    # byebug
  end
end
