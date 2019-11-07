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

ActiveRecord::Schema.define(version: 2019_11_06_230131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
  end

  create_table "inspection_types", force: :cascade do |t|
    t.bigint "client_id"
    t.string "uuid"
    t.integer "interval"
    t.string "name"
    t.date "first_inspection_date"
    t.index ["client_id"], name: "index_inspection_types_on_client_id"
  end

  create_table "inspections", force: :cascade do |t|
    t.bigint "inspection_type_id"
    t.bigint "client_id"
    t.date "due_date"
    t.string "uuid"
    t.boolean "complete", default: false
    t.integer "score"
    t.index ["client_id"], name: "index_inspections_on_client_id"
    t.index ["inspection_type_id"], name: "index_inspections_on_inspection_type_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "inspection_type_id"
    t.bigint "client_id"
    t.integer "sequence"
    t.boolean "allow_not_applicable_response", default: false
    t.string "uuid"
    t.text "text"
    t.jsonb "answers"
    t.index ["client_id"], name: "index_questions_on_client_id"
    t.index ["inspection_type_id"], name: "index_questions_on_inspection_type_id"
  end

end
