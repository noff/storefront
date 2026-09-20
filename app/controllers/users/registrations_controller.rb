module Users
  # Переопределяем регистрацию, чтобы отметить успешное создание аккаунта для трекинга.
  class RegistrationsController < Devise::RegistrationsController
    def create
      super
      session[:signed_up] = true if resource.persisted?
    end
  end
end
