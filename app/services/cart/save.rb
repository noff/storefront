# frozen_string_literal: true

module Cart
  class Save < ApplicationService

    attr_reader :products, :session

    # @param [Array<DTO::Cart::Item>] products
    # @param [ActionDispatch::Request::Session] session
    def initialize(products:, session:)
      @products = products
      @session = session
    end

    # Сохраняем текущую корзину
    # @return Boolean
    def call
      # Ключи строковые: так формат в сессии одинаков до и после
      # JSON-сериализации куки, и чтение в том же запросе не ломается.
      session[:cart] = products.map do |item|
        {
          "product_id" => item.product.id,
          "quantity" => item.quantity,
        }
      end
      true
    end
  end
end
