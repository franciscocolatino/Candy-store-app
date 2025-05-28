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

ActiveRecord::Schema[8.0].define(version: 2025_05_20_142221) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "lots", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.date "expiration_date"
    t.date "manufacturing_date"
    t.date "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_lots_on_product_id"
  end

  create_table "order_lots", primary_key: ["order_id", "lot_id"], force: :cascade do |t|
    t.integer "quantity", default: 1, null: false
    t.boolean "is_delivered", default: false
    t.float "subtotal", default: 0.0, null: false
    t.bigint "order_id", null: false
    t.bigint "lot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lot_id"], name: "index_order_lots_on_lot_id"
    t.index ["order_id"], name: "index_order_lots_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.float "total_price", default: 0.0
    t.boolean "is_finished", default: false
    t.datetime "date", default: -> { "CURRENT_TIMESTAMP" }
    t.bigint "table_id"
    t.string "user_cpf", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_orders_on_table_id"
    t.index ["user_cpf"], name: "index_orders_on_user_cpf"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "category"
    t.decimal "price", precision: 10, scale: 2
    t.date "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tables", force: :cascade do |t|
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "cpf", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "lots", "products"
  add_foreign_key "order_lots", "lots"
  add_foreign_key "order_lots", "orders"
  add_foreign_key "orders", "tables"
  add_foreign_key "orders", "users", column: "user_cpf", primary_key: "cpf"
end
