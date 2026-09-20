# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_20_094100) do
  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ext_id"
    t.string "name"
    t.string "parent_id"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["ext_id"], name: "index_categories_on_ext_id", unique: true
  end

  create_table "favorites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "product_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id", "product_id"], name: "index_favorites_on_user_id_and_product_id", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "order_id"
    t.integer "price"
    t.integer "product_id"
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "total"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "available"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "ext_id"
    t.string "name"
    t.integer "old_price"
    t.text "params"
    t.string "picture"
    t.integer "price"
    t.decimal "rating"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "vendor"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["ext_id"], name: "index_products_on_ext_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
