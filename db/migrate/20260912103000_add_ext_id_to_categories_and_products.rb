class AddExtIdToCategoriesAndProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :ext_id, :string
    add_column :categories, :url, :string
    add_index :categories, :ext_id, unique: true

    add_column :products, :ext_id, :string
    add_column :products, :url, :string
    add_column :products, :vendor, :string
    add_index :products, :ext_id, unique: true
    add_index :products, :category_id
  end
end
