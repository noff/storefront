require "test_helper"

class CitiesControllerTest < ActionDispatch::IntegrationTest
  test "selecting a city stores it in a cookie and redirects back" do
    patch city_url(code: "spb"), headers: { "HTTP_REFERER" => root_url }

    assert_redirected_to root_url
    assert_equal "spb", cookies[:city]
  end

  test "unknown code leaves the cookie untouched" do
    cookies[:city] = "spb"
    patch city_url(code: "paris")

    assert_redirected_to root_url
    assert_equal "spb", cookies[:city]
  end

  test "header shows Moscow by default" do
    get root_url

    assert_select ".dropdown button", text: /Москва/
  end

  test "header shows the city from the cookie" do
    cookies[:city] = "spb"
    get root_url

    assert_select ".dropdown button", text: /Санкт-Петербург/
  end
end
