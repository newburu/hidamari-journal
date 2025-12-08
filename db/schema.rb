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

ActiveRecord::Schema[8.1].define(version: 2025_12_08_013515) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "annual_themes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "kanji"
    t.text "meaning"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "year"
    t.index ["user_id"], name: "index_annual_themes_on_user_id"
  end

  create_table "daily_tasks", force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "monthly_goal_id"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["monthly_goal_id"], name: "index_daily_tasks_on_monthly_goal_id"
    t.index ["user_id"], name: "index_daily_tasks_on_user_id"
  end

  create_table "mandala_items", force: :cascade do |t|
    t.bigint "annual_theme_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.boolean "is_center"
    t.bigint "parent_id"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["annual_theme_id"], name: "index_mandala_items_on_annual_theme_id"
    t.index ["parent_id"], name: "index_mandala_items_on_parent_id"
  end

  create_table "monthly_goals", force: :cascade do |t|
    t.bigint "annual_theme_id", null: false
    t.datetime "created_at", null: false
    t.text "goal"
    t.bigint "mandala_item_id"
    t.integer "month"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["annual_theme_id"], name: "index_monthly_goals_on_annual_theme_id"
    t.index ["mandala_item_id"], name: "index_monthly_goals_on_mandala_item_id"
    t.index ["user_id"], name: "index_monthly_goals_on_user_id"
  end

  create_table "reflections", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "reflection_type"
    t.integer "score"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_reflections_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "annual_themes", "users"
  add_foreign_key "daily_tasks", "monthly_goals"
  add_foreign_key "daily_tasks", "users"
  add_foreign_key "mandala_items", "annual_themes"
  add_foreign_key "mandala_items", "mandala_items", column: "parent_id"
  add_foreign_key "monthly_goals", "annual_themes"
  add_foreign_key "monthly_goals", "mandala_items"
  add_foreign_key "monthly_goals", "users"
  add_foreign_key "reflections", "users"
end
