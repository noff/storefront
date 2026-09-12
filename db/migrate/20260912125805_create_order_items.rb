class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.belongs_to :order
      t.belongs_to :product
      t.integer :quantity
      t.integer :price
      t.timestamps
    end
  end
end
