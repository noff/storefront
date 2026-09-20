require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "to_param returns ext_id" do
    assert_equal "running", categories(:running).to_param
  end
end
