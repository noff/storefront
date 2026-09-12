class CartsController < ApplicationController
  def show
    @cart = current_cart.sort_by { |x| x.product.name }
  end

  def add
    product = Product.find params[:product_id]
    Cart::Add.call product: product, quantity: 1, session: session
    redirect_back fallback_location: root_path
  end

  def remove
    Cart::Remove.call product_id: params[:product_id], session: session
    redirect_back fallback_location: root_path
  end

  def increase
    product = Product.find params[:product_id]
    cart = current_cart
    item = cart.select { |x| x.product.id == product.id }.first
    if item
      Cart::Add.call session: session, product: item.product, quantity: 1
    end
    redirect_back fallback_location: root_path
  end

  def decrease
    product = Product.find params[:product_id]
    cart = current_cart
    item = cart.select { |x| x.product.id == product.id }.first
    if item
      if item.quantity == 1
        Cart::Remove.call session: session, product_id: item.product.id
      else
        Cart::Add.call session: session, product: item.product, quantity: -1
      end
    end
    redirect_back fallback_location: root_path
  end

end
