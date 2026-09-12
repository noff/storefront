# frozen_string_literal: true

module DTO
  module Cart
    class Item

      attr_reader :product, :quantity

      # @param [Product] product
      # @param [Integer] quantity
      def initialize(product:, quantity:)
        @product = product
        @quantity = quantity
      end
    end
  end
end
