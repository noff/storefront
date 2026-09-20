class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  # Полная стоимость заказа
  # @return Integer
  def total
    order_items.sum { |x| x.price * x.quantity }
  end

end
