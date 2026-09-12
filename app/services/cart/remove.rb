# frozen_string_literal: true

module Cart
  class Remove < ApplicationService

    attr_reader :product_id, :session

    # @param [Integer] product_id
    # @param [ActionDispatch::Request::Session] session
    def initialize(product_id:, session:)
      @product_id = product_id.to_i
      @session = session
    end

    # Удаляет товар из корзины
    def call
      cart = Cart::Get.call session: session
      cart = cart.reject { |item| item.product.id == product_id }
      Cart::Save.call products: cart, session: session
    end
  end
end
