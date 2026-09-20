# frozen_string_literal: true

module Cart
  class Add < ApplicationService

    attr_reader :product, :quantity, :session

    # @param [Product] product
    # @param [Integer] quantity
    # @param [ActionDispatch::Request::Session] session
    def initialize(product:, quantity:, session:)
      @product = product
      @quantity = quantity
      @session = session
    end

    # Добавляет товар в корзину, увеличивая количество уже лежащей позиции
    def call
      cart = Cart::Get.call session: session
      existing = cart.find { |item| item.product.ext_id == product.ext_id }

      item = DTO::Cart::Item.new(
        product: product,
        quantity: existing.nil? ? quantity : existing.quantity + quantity,
      )

      cart = cart.reject { |x| x.product.ext_id == product.ext_id }
      cart << item

      Cart::Save.call products: cart, session: session
    end
  end
end
