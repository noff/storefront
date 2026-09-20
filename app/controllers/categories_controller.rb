class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(ext_id: params[:id])
    @products = @category.products.limit(100)
    @subcategories = @category.children

    @breadcrumbs = @category.ancestors
  end
end
