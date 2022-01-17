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

ActiveRecord::Schema.define(version: 2021_11_22_145653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "campaigns_prospects", id: false, force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "prospect_id", null: false
    t.index ["campaign_id", "prospect_id"], name: "index_campaigns_prospects_on_campaign_id_and_prospect_id"
    t.index ["prospect_id", "campaign_id"], name: "index_campaigns_prospects_on_prospect_id_and_campaign_id"
  end

  create_table "prospects", force: :cascade do |t|
    t.string "email"
    t.text "first_name"
    t.text "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_prospects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "campaigns", "users"
  add_foreign_key "prospects", "users"
end
