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

ActiveRecord::Schema[7.0].define(version: 2023_09_08_084506) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "role", default: "admin"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "kycs", force: :cascade do |t|
    t.string "fullName"
    t.date "birthday"
    t.string "address"
    t.string "idType"
    t.string "idNumber"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_kycs_on_user_id"
  end

  create_table "portfolio_items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "token_id", null: false
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token_id"], name: "index_portfolio_items_on_token_id"
    t.index ["user_id"], name: "index_portfolio_items_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "ticker"
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_id"
    t.index ["external_id"], name: "index_tokens_on_external_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.string "transaction_type"
    t.float "transaction_amount"
    t.float "transaction_price"
    t.integer "user_id", null: false
    t.integer "token_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "usd_value"
    t.index ["token_id"], name: "index_transactions_on_token_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kyc_status"
    t.decimal "balance", precision: 15, scale: 10, default: "1000.0"
    t.string "role", default: "user"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "kycs", "users"
  add_foreign_key "portfolio_items", "tokens"
  add_foreign_key "portfolio_items", "users"
  add_foreign_key "transactions", "tokens"
  add_foreign_key "transactions", "users"
end
