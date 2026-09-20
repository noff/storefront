require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "to_param returns ext_id" do
    product = products(:air_max)

    assert_equal "air-max-pro", product.to_param
  end
end
