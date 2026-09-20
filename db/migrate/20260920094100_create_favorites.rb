class CreateFavorites < ActiveRecord::Migration[8.1]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :product_id
      t.timestamps
    end
    add_index :favorites, [ :user_id, :product_id ], unique: true
  end
end
