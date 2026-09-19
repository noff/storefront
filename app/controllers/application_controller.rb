class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_cart, :current_city

  private

  # Содержимое корзины текущей сессии
  # @return [Array<DTO::Cart::Item>]
  def current_cart
    @current_cart ||= Cart::Get.call(session: session)
  end

  # Город из cookie; невалидный или отсутствующий код даёт Москву.
  # @return [City]
  def current_city
    @current_city ||= City.find_or_default(cookies[:city])
  end
end
