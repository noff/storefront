class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.limit(100)
    @subcategories = @category.children

    @breadcrumbs = @category.ancestors
  end
end
