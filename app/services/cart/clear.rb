# frozen_string_literal: true

module Cart
  class Clear < ApplicationService

    attr_reader :session

    # @param [ActionDispatch::Request::Session] session
    def initialize(session:)
      @session = session
    end

    # Очистить корзину
    def call
      session[:cart] = []
    end
  end
end
