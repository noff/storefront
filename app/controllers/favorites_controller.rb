class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    product = Product.find_by! ext_id: params[:product_id]
    # Повторный клик не должен падать на уникальном индексе.
    current_user.favorites.find_or_create_by! product: product
    session[:added_to_wish] = product.ext_id
    redirect_back fallback_location: product_path(product)
  end

  def destroy
    product = Product.find_by! ext_id: params[:product_id]
    current_user.favorites.where(product: product).destroy_all
    session[:removed_from_wish] = product.ext_id
    redirect_back fallback_location: product_path(product)
  end
end
