require "test_helper"

class ProspectTest < ActiveSupport::TestCase

    test "make sure prospects can be created without project_import reference" do
        user = User.create! email: "test@test.com", password: "sample"
        prospect = user.prospects.new email: "test@example.com", first_name: "user", last_name: "awesome"
        assert prospect.save, prospect.errors.full_messages
    end
  
end
