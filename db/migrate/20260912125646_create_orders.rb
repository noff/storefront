class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.integer :total
      t.timestamps
    end
  end
end
