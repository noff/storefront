require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "url is built from ext_id and resolves by it" do
    category = categories(:running)

    assert_equal "/categories/running", category_path(category)

    get "/categories/running"
    assert_response :success
    assert_select "h1", category.name
  end

  test "subcategory and product links use ext_id" do
    get category_url(categories(:shoes))

    assert_response :success
    assert_select "a[href=?]", "/categories/running"
  end

  test "lookup by primary key returns 404" do
    get "/categories/#{categories(:running).id}"

    assert_response :not_found
  end
end
