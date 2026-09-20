require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup { sign_in users(:alice) }

  test "creates an order from a cart addressed by ext_id" do
    patch add_cart_url(product_id: "air-max-pro")

    assert_difference "Order.count", 1 do
      post orders_url
    end

    order = Order.last
    assert_redirected_to order_url(order)
    assert_equal [ products(:air_max) ], order.order_items.map(&:product)
    assert_equal products(:air_max).price, order.total
    assert_empty session[:cart]
  end

  test "order page links to products by ext_id" do
    patch add_cart_url(product_id: "air-max-pro")
    post orders_url

    follow_redirect!
    assert_response :success
    assert_select "a[href=?]", "/products/air-max-pro"
  end
end
