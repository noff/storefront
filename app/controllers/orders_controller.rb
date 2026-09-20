class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    cart = Cart::Get.call(session: session)
    unless cart.any?
      redirect_to root_path and return
    end
    Order.transaction do
      order = current_user.orders.create!
      cart.each do |item|
        order.order_items.create! product: item.product, quantity: item.quantity, price: item.product.price
      end
      total = cart.map { |x| x.product.price * x.quantity }.sum
      order.update! total: total
      Cart::Clear.call session: session
      session[:order_created] = order.id
      redirect_to order_path(order), notice: "Заказ создан"
    end
  rescue => e
    redirect_to root_path, alert: e.message
  end

  def show
    @order = current_user.orders.find params[:id]
  end

  def index
    @orders = current_user.orders.order(id: :desc)
  end

  def destroy
    order = current_user.orders.find(params[:id])
    order.destroy
    redirect_back(fallback_location: orders_path)
  end
end
