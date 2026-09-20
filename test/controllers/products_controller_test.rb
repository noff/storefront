require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    product = products(:air_max)
    get product_url(product)

    assert_response :success
    assert_select "h1", product.name
  end

  test "url is built from ext_id and resolves by it" do
    product = products(:air_max)

    assert_equal "/products/air-max-pro", product_path(product)

    get "/products/air-max-pro"
    assert_response :success
  end

  test "lookup by primary key returns 404" do
    get "/products/#{products(:air_max).id}"

    assert_response :not_found
  end

  test "renders breadcrumbs up to the product category" do
    get product_url(products(:air_max))

    assert_select "nav[aria-label=?] a", "Хлебные крошки", text: "Обувь"
    assert_select "nav[aria-label=?] a", "Хлебные крошки", text: "Кроссовки"
  end

  test "renders product without category or params" do
    get product_url(products(:sold_out))

    assert_response :success
    assert_select "nav[aria-label=?]", "Хлебные крошки", count: 0
  end
end
