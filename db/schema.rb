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

ActiveRecord::Schema[7.2].define(version: 2024_08_22_013626) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_authors_on_name"
  end

  create_table "competences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_competences_on_name", unique: true
  end

  create_table "course_competences", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "competence_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competence_id"], name: "index_course_competences_on_competence_id"
    t.index ["course_id", "competence_id"], name: "index_course_competences_on_course_id_and_competence_id", unique: true
    t.index ["course_id"], name: "index_course_competences_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_courses_on_author_id"
    t.index ["name"], name: "index_courses_on_name"
  end

  add_foreign_key "course_competences", "competences"
  add_foreign_key "course_competences", "courses"
  add_foreign_key "courses", "authors"
end
