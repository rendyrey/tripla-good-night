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

ActiveRecord::Schema[8.0].define(version: 2025_01_22_033536) do
  create_table "sleep_records", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "sleep_at"
    t.datetime "wake_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
  end

  create_table "user_followings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "followed_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_user_id"], name: "index_user_followings_on_followed_user_id"
    t.index ["user_id", "followed_user_id"], name: "index_user_followings_on_user_id_and_followed_user_id", unique: true
    t.index ["user_id"], name: "index_user_followings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "sleep_records", "users"
  add_foreign_key "user_followings", "users"
  add_foreign_key "user_followings", "users", column: "followed_user_id"
end
