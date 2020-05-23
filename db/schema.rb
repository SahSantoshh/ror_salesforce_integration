# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_23_074107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "type"
    t.string "sf_id"
    t.string "owner_id"
    t.string "parent_id"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.string "email"
    t.string "phone"
    t.string "mobile_phone"
    t.boolean "is_deleted"
    t.string "sf_id"
    t.string "sf_account_id"
    t.string "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "push_topics", force: :cascade do |t|
    t.string "sf_id"
    t.boolean "is_account"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
