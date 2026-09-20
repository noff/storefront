require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "adds product to cart by ext_id" do
    patch add_cart_url(product_id: "air-max-pro")

    assert_redirected_to root_url
    assert_equal [ { "product_id" => "air-max-pro", "quantity" => 1 } ], session[:cart]
  end

  test "cart form posts ext_id" do
    get product_url(products(:air_max))

    assert_select "form[action=?]", "/cart/add?product_id=air-max-pro"
  end

  test "increase and decrease find the item by ext_id" do
    patch add_cart_url(product_id: "air-max-pro")
    patch increase_cart_url(product_id: "air-max-pro")

    assert_equal 2, session[:cart].first["quantity"]

    patch decrease_cart_url(product_id: "air-max-pro")
    assert_equal 1, session[:cart].first["quantity"]

    patch decrease_cart_url(product_id: "air-max-pro")
    assert_empty session[:cart]
  end

  test "removes product from cart by ext_id" do
    patch add_cart_url(product_id: "air-max-pro")
    delete remove_cart_url(product_id: "air-max-pro")

    assert_empty session[:cart]
  end

  test "unknown ext_id returns 404" do
    patch add_cart_url(product_id: products(:air_max).id)

    assert_response :not_found
  end
end
