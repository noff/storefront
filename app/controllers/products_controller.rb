class ProductsController < ApplicationController
  def show
    @product = Product.includes(:category).find(params[:id])

    category = @product.category
    # Крошки ведут до категории товара включительно — сам товар в них не ссылка.
    @breadcrumbs = category ? category.ancestors + [ category ] : []
  end
end
