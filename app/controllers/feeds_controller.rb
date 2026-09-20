# frozen_string_literal: true

# Товарный фид в формате YML. Отдаётся потоково прямо по запросу:
# ответ начинает литься сразу, поэтому в таймаут прокси не упираемся.
#
# Наследуемся от ActionController::Base, а не от ApplicationController:
# фид тянут импортёры и краулеры, проверка версии браузера и хелперы
# корзины/города здесь только мешают.
class FeedsController < ActionController::Base
  def show
    response.headers["Content-Type"] = "application/xml; charset=utf-8"

    self.response_body = Feed::Yml.call(base_url: feed_base_url)
  end

  private

  # На локалхосте это http://localhost:3000, в проде — домен витрины.
  # FEED_BASE_URL нужен за nginx+certbot: схему https до Rails прокси не доносит.
  def feed_base_url
    ENV.fetch("FEED_BASE_URL", request.base_url)
  end
end
