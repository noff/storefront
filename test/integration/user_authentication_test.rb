require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  test "регистрация без подтверждения email сразу логинит" do
    get new_user_registration_path
    assert_response :success

    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: { email: "new-user@example.com", password: "password", password_confirmation: "password" }
      }
    end

    assert_redirected_to root_path

    # Страница профиля доступна только своему пользователю — значит, вход выполнен.
    get edit_user_registration_path
    assert_response :success
  end

  test "успешная регистрация трекает signed_up один раз" do
    post user_registration_path, params: {
      user: { email: "tracked-user@example.com", password: "password", password_confirmation: "password" }
    }

    follow_redirect!
    assert_match 'r46("track", "signed_up")', @response.body
    assert_no_match 'r46("track", "signed_in")', @response.body

    # Флаг одноразовый: на следующей странице события уже нет.
    get root_path
    assert_no_match 'r46("track", "signed_up")', @response.body
  end

  test "успешный вход трекает signed_in один раз" do
    post user_session_path, params: { user: { email: users(:alice).email, password: "password" } }

    follow_redirect!
    assert_match 'r46("track", "signed_in")', @response.body

    get root_path
    assert_no_match 'r46("track", "signed_in")', @response.body
  end

  test "неудачный вход не трекает signed_in" do
    post user_session_path, params: { user: { email: users(:alice).email, password: "wrong" } }
    assert_no_match 'r46("track", "signed_in")', @response.body

    get root_path
    assert_no_match 'r46("track", "signed_in")', @response.body
  end

  test "вход и выход" do
    get new_user_session_path
    assert_response :success

    post user_session_path, params: { user: { email: users(:alice).email, password: "password" } }
    assert_redirected_to root_path

    get edit_user_registration_path
    assert_response :success

    delete destroy_user_session_path
    assert_redirected_to root_path

    get edit_user_registration_path
    assert_redirected_to new_user_session_path
  end

  test "неверный пароль показывает ошибку" do
    post user_session_path, params: { user: { email: users(:alice).email, password: "wrong" } }
    assert_response :unprocessable_content
    assert_match "Неверный email или пароль", @response.body
  end
end
