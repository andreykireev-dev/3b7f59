require "test_helper"

class ProspectTest < ActiveSupport::TestCase

  setup do
    @user = User.create email: "test@test.com", password: "sample"
  end


  test 'import method should import prospects from file - happy path' do
    
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
        
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First1", first_prospect.first_name
    assert_equal "Last1", first_prospect.last_name
  end

  test 'import method should import prospects from file - no header' do
    
    test_file_path = "#{fixture_path}files/valid_prospects_import_wo-header_1.csv"
    file = File.new(test_file_path)

    result = @user.prospects.import(
      file: file,
      email_index: 0,
      first_name_index: 1,
      last_name_index: 2,
      force: true,
      has_headers: false
      )
    assert result[:imported]
    refute result[:errors]
    @user.reload

    assert_equal 35, @user.prospects.count
        
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First1", first_prospect.first_name
    assert_equal "Last1", first_prospect.last_name
  end

  test 'import method should import prospects from file - alternate' do
    
    test_file_path = "#{fixture_path}files/valid_prospects_import_w-header_2.csv"
    file = File.new(test_file_path)

    result = @user.prospects.import(
      file: file,
      email_index: 1,
      first_name_index: 0,
      last_name_index: 2,
      force: true,
      has_headers: true
      )
    assert result[:imported]
    refute result[:errors]
    @user.reload

    assert_equal 35, @user.prospects.count
        
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First1", first_prospect.first_name
    assert_equal "Last1", first_prospect.last_name
  end

  test 'import method should import prospects from file - no header alternate' do
    
    test_file_path = "#{fixture_path}files/valid_prospects_import_wo-header_2.csv"
    file = File.new(test_file_path)

    result = @user.prospects.import(
      file: file,
      email_index: 1,
      first_name_index: 0,
      last_name_index: 2,
      force: true,
      has_headers: false
      )
    assert result[:imported]
    refute result[:errors]
    @user.reload

    assert_equal 35, @user.prospects.count
    
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First1", first_prospect.first_name
    assert_equal "Last1", first_prospect.last_name


  end

  test 'import with duplicate values should retain last values (overwrite)' do
    
    test_file_path = "#{fixture_path}files/duplicate_values.csv"
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

    assert_equal 1, @user.prospects.count
    
    first_prospect = Prospect.first

    assert_equal "email1@example.com", first_prospect.email
    assert_equal "First3", first_prospect.first_name
    assert_equal "Last3", first_prospect.last_name


  end
end
