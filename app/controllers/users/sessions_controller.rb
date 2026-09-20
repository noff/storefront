module Users
  # Переопределяем вход, чтобы отметить успешную аутентификацию для трекинга.
  class SessionsController < Devise::SessionsController
    def create
      super
      session[:signed_in] = true
    end
  end
end
