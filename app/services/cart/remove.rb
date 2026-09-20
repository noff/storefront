# frozen_string_literal: true

module Cart
  class Remove < ApplicationService

    attr_reader :product_ext_id, :session

    # @param [String] product_ext_id
    # @param [ActionDispatch::Request::Session] session
    def initialize(product_ext_id:, session:)
      @product_ext_id = product_ext_id.to_s
      @session = session
    end

    # Удаляет товар из корзины
    def call
      cart = Cart::Get.call session: session
      cart = cart.reject { |item| item.product.ext_id == product_ext_id }
      Cart::Save.call products: cart, session: session
    end
  end
end
