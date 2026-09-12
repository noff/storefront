class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.integer :old_price
      t.text :params
      t.boolean :available
      t.integer :category_id
      t.timestamps
    end
  end
end
