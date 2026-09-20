# frozen_string_literal: true

module Cart
  class Get < ApplicationService

    attr_reader :session

    # @param [ActionDispatch::Request::Session] session
    def initialize(session:)
      @session = session
    end

    # Получаем содержимое корзины
    # @return [Array<DTO::Cart::Item>]
    def call
      raw = session[:cart]
      return [] unless raw.is_a?(Array) && raw.present?

      products = Product.where(ext_id: raw.filter_map { |item| item_ext_id(item) }).index_by(&:ext_id)

      raw.filter_map do |item|
        product = products[item_ext_id(item)]
        next if product.nil?

        DTO::Cart::Item.new(product: product, quantity: item_quantity(item))
      end
    end

    private

    # В сессии ключи приходят строками (JSON-сериализация куки),
    # но в рамках текущего запроса они ещё символьные.
    # Значение — ext_id товара, строка.
    def item_ext_id(item)
      (item["product_id"] || item[:product_id])&.to_s
    end

    def item_quantity(item)
      (item["quantity"] || item[:quantity]).to_i
    end
  end
end
