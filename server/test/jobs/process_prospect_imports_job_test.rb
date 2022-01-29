require "test_helper"

class ProcessProspectImportsJobTest < ActiveJob::TestCase

  include ActiveJob::TestHelper


  setup do
    @user = User.create! email: "test@test.com", password: "sample"
    @test_file = {
      path: "#{fixture_path}files/",
      name: "valid_prospects_import_w-header_1.csv",
      content_type: "text/csv"
    }

    @file = File.new(@test_file[:path] + @test_file[:name])

    @prospect_import = @user.prospect_imports.new(
      email_index: 0,
      first_name_index: 1, 
      last_name_index: 2,
      force: true,
      has_headers: true,
      original_filename: @test_file[:name]
    )

    @prospect_import.file.attach io: @file, filename: @test_file[:name]
    @prospect_import.save
    
  end

  def after_teardown
    super
    # clean up test file storage
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end



  test "running job should import prospects" do

    ProcessProspectImportsJob.perform_now(@prospect_import)

    assert @prospect_import.completed?
    assert_equal 35, @user.prospects.count


  end

  test "run_later should enqueue the job" do 
    assert_enqueued_with(job: ProcessProspectImportsJob) do
      @prospect_import.run_later
      assert @prospect_import.queued?
    end
  end
end
