require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @product = products(:air_max)
  end

  test "гостю показывается ссылка на вход вместо кнопки" do
    get product_url(@product)

    assert_select "form[action=?]", favorites_path(product_id: @product.ext_id), false
    assert_match "Войдите, чтобы добавить в избранное", response.body
  end

  test "гостя редиректит на вход вместо добавления" do
    assert_no_difference "Favorite.count" do
      post favorites_url, params: { product_id: @product.ext_id }
    end

    assert_redirected_to new_user_session_path
  end

  test "добавление в избранное трекается как wish" do
    sign_in_as @user

    assert_difference "Favorite.count", 1 do
      post favorites_url, params: { product_id: @product.ext_id },
           headers: { "HTTP_REFERER" => product_url(@product) }
    end

    follow_redirect!
    assert_match %(r46("track", "wish", "#{@product.ext_id}")), response.body
    assert_select "form[action=?]", favorite_path(product_id: @product.ext_id)
  end

  test "повторное добавление не плодит дубли" do
    sign_in_as @user
    post favorites_url, params: { product_id: @product.ext_id }

    assert_no_difference "Favorite.count" do
      post favorites_url, params: { product_id: @product.ext_id }
    end
  end

  test "удаление из избранного трекается как remove_wish" do
    sign_in_as @user
    @user.favorites.create! product: @product

    assert_difference "Favorite.count", -1 do
      delete favorite_url(product_id: @product.ext_id),
             headers: { "HTTP_REFERER" => product_url(@product) }
    end

    follow_redirect!
    assert_match %(r46("track", "remove_wish", "#{@product.ext_id}")), response.body
    assert_select "form[action=?]", favorites_path(product_id: @product.ext_id)
  end

  test "трек-скрипт не повторяется на следующей странице" do
    sign_in_as @user
    post favorites_url, params: { product_id: @product.ext_id }
    follow_redirect!

    get root_url
    assert_not_includes response.body, "r46(\"track\", \"wish\""
  end

  test "неизвестный ext_id даёт 404" do
    sign_in_as @user

    post favorites_url, params: { product_id: @product.id }

    assert_response :not_found
  end

  private

  def sign_in_as(user)
    post user_session_url, params: { user: { email: user.email, password: "password" } }
  end
end
