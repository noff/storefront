class AddColumnsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :rating, :decimal
    add_column :products, :picture, :string
  end
end
