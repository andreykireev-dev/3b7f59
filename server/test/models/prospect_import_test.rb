require "test_helper"

class ProspectImportTest < ActiveSupport::TestCase

  setup do
    @user = User.create! email: "test@test.com", password: "sample"
    @test_file = {
      path: "#{fixture_path}files/",
      name: "valid_prospects_import_w-header_1.csv",
      content_type: "text/csv"
    }

    @prospect_import = @user.prospect_imports.new(
      email_index: 0,
      first_name_index: 1, 
      last_name_index: 2,
      force: true,
      has_headers: true,
      original_filename: @test_file[:name]
    )


    
  end

  def after_teardown
    super
    # clean up test file storage
    # FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end


  test "should be able to store import attachment in DB" do

    file = File.new(@test_file[:path] + @test_file[:name])
    prospect_import = @prospect_import.dup

    assert prospect_import.uploading?
    prospect_import.file.attach io: file, filename: @prospect_import.original_filename

    assert prospect_import.save

    assert 1, @user.prospect_imports.count



  end


  test 'run method should import prospects from file - happy path' do
    
    @test_file[:name] = "valid_prospects_import_w-header_1.csv"

    file = File.open(@test_file[:path] + @test_file[:name])

    prospect_import = @user.prospect_imports.new(
      email_index: 0,
      first_name_index: 1,
      last_name_index: 2,
      force: true,
      has_headers: true,
      original_filename: @test_file[:name]
    )
    assert prospect_import.save

    prospect_import.file.attach io: file, filename: @prospect_import.original_filename

    result = prospect_import.run

    assert result[:imported]
    refute result[:errors]

    assert_equal 35, @user.prospects.count
    
    assert prospect_import.completed?
        
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First1", first_prospect.first_name
    assert_equal "Last1", first_prospect.last_name
  end

  test 'import method should import prospects from file - no header' do
    
    @test_file[:name] = "valid_prospects_import_wo-header_1.csv"

    file = File.open(@test_file[:path] + @test_file[:name])

    prospect_import = @user.prospect_imports.new(
      email_index: 0,
      first_name_index: 1,
      last_name_index: 2,
      force: true,
      has_headers: false,
      original_filename: @test_file[:name]
    )
    assert prospect_import.save

    prospect_import.file.attach io: file, filename: @prospect_import.original_filename

    result = prospect_import.run

    assert result[:imported]
    refute result[:errors]

    assert_equal 35, @user.prospects.count
        
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First1", first_prospect.first_name
    assert_equal "Last1", first_prospect.last_name
  end

  test 'import method should import prospects from file - alternate' do
    
    @test_file[:name] = "valid_prospects_import_w-header_2.csv"

    file = File.open(@test_file[:path] + @test_file[:name])

    prospect_import = @user.prospect_imports.new(
      email_index: 1,
      first_name_index: 0,
      last_name_index: 2,
      force: true,
      has_headers: true,
      original_filename: @test_file[:name]
    )
    assert prospect_import.save

    prospect_import.file.attach io: file, filename: @prospect_import.original_filename

    result = prospect_import.run

    assert result[:imported]
    refute result[:errors]

    assert_equal 35, @user.prospects.count
        
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First1", first_prospect.first_name
    assert_equal "Last1", first_prospect.last_name
  end

  test 'import method should import prospects from file - no header alternate' do
    
    @test_file[:name] = "valid_prospects_import_wo-header_2.csv"

    file = File.open(@test_file[:path] + @test_file[:name])

    prospect_import = @user.prospect_imports.new(
      email_index: 1,
      first_name_index: 0,
      last_name_index: 2,
      force: true,
      has_headers: false,
      original_filename: @test_file[:name]
    )

    assert prospect_import.save

    prospect_import.file.attach io: file, filename: @prospect_import.original_filename

    result = prospect_import.run

    assert result[:imported]
    refute result[:errors]

    assert_equal 35, @user.prospects.count
    
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First1", first_prospect.first_name
    assert_equal "Last1", first_prospect.last_name


  end

  test 'import with duplicate values should retain last values (overwrite)' do
    
    @test_file[:name] = "duplicate_values.csv"

    file = File.open(@test_file[:path] + @test_file[:name])

    prospect_import = @user.prospect_imports.new(
      email_index: 0,
      first_name_index: 1,
      last_name_index: 2,
      force: true,
      has_headers: true,
      original_filename: @test_file[:name]
    )
    assert prospect_import.save

    prospect_import.file.attach io: file, filename: @prospect_import.original_filename

    result = prospect_import.run


    assert result[:imported]
    refute result[:errors]

    assert_equal 1, @user.prospects.count
    
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First3", first_prospect.first_name
    assert_equal "Last3", first_prospect.last_name
  end

  test 'import file over 1m rows should not work' do
    
    large_file = '1mrows.txt'

    f = File.open(large_file, "w+") 

    for i in 1..1000005 do
      f.write "Line #{i}\n"
    end
    
    f.close

    @test_file[:name] = large_file

    file = File.open(@test_file[:name])

    prospect_import = @user.prospect_imports.new(
      email_index: 0,
      first_name_index: 1,
      last_name_index: 2,
      force: true,
      has_headers: true,
      original_filename: @test_file[:name]
    )
    assert prospect_import.save

    prospect_import.file.attach io: file, filename: @prospect_import.original_filename

    result = prospect_import.run

    refute result[:imported], result
    assert result[:errors], result
    assert_equal "CSV row size exceeded. Only files smaller than 1m rows are acceptable", result[:error_messages]

    File.delete(large_file)

  end

  test 'import file over 200BV should not work' do
    
    large_file = '200mb.txt'

    f = File.open(large_file, "w+") 

    file_data = "0" * 200
    file_limit = 1024 * 1024 + 10

    for i in 1..file_limit do
      f.write file_data
    end
    
    f.close


    @test_file[:name] = large_file

    file = File.open(@test_file[:name])

    prospect_import = @user.prospect_imports.new(
      email_index: 0,
      first_name_index: 1,
      last_name_index: 2,
      force: true,
      has_headers: true,
      original_filename: @test_file[:name]
    )
    assert prospect_import.save

    prospect_import.file.attach io: file, filename: @prospect_import.original_filename

    result = prospect_import.run

    refute result[:imported], result
    assert result[:errors], result
    assert_equal "CSV file size exceeded. Only files smaller than 200MB are acceptable", result[:error_messages]

    File.delete(large_file)

  end

end
