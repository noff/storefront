class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.limit(100)
    @subcategories = @category.children

    @breadcrumbs = []
    parent = @category.parent
    while true
      break if parent.nil?
      @breadcrumbs << parent
      parent = parent.parent
    end
    @breadcrumbs.reverse!
  end
end
