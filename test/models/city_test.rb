require "test_helper"

class CityTest < ActiveSupport::TestCase
  test "find returns city by code" do
    assert_equal "Санкт-Петербург", City.find("spb").name
  end

  test "find returns nil for unknown code" do
    assert_nil City.find("paris")
    assert_nil City.find(nil)
  end

  test "find_or_default falls back to Moscow" do
    assert_equal "moscow", City.find_or_default("paris").code
    assert_equal "moscow", City.find_or_default(nil).code
    assert_equal "spb", City.find_or_default("spb").code
  end
end
