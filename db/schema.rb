# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170131121744) do

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "contact_person"
    t.string   "email"
    t.string   "phone_number"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.string   "name"
    t.integer  "product_id"
    t.integer  "warehouse_id"
    t.integer  "pallet_count"
    t.integer  "case_count"
    t.integer  "each_count"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "each_in_case"
    t.integer  "cases_in_layer"
    t.integer  "layers_in_pallet"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "transfers", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "warehouse_id"
    t.integer  "customer_id"
    t.integer  "quantity"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
  end

  create_table "warehouses", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
