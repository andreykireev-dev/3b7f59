require "test_helper"

class ProspectImportTest < ActiveSupport::TestCase

  setup do
    @user = User.create! email: "test@test.com", password: "sample"
    @test_file = {
      path: "#{fixture_path}files/",
      name: "valid_prospects_import_w-header_1.csv",
      content_type: "text/csv"
    }
    
  end

  def after_teardown
    super
    # clean up test file storage
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end


  test "should be able to store import attachment in DB" do
    prospect_import = @user.prospect_imports.new

    file = File.new(@test_file[:path] + @test_file[:name])

    
    prospect_import.file.attach io: file, filename: @test_file[:name]

    assert prospect_import.save
    assert 1, @user.prospect_imports.count
    
  end
end
