require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    product = products(:air_max)
    get product_url(product)

    assert_response :success
    assert_select "h1", product.name
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
