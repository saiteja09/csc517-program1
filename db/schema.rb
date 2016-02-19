# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160207231705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_materials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
    t.integer  "task_id"
  end

  add_index "course_materials", ["course_id"], name: "index_course_materials_on_course_id", using: :btree
  add_index "course_materials", ["task_id"], name: "index_course_materials_on_task_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "coursenumber",                           null: false
    t.string   "title",                                  null: false
    t.string   "description",                            null: false
    t.date     "start_date",                             null: false
    t.date     "end_date",                               null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "instructor_id"
    t.boolean  "status",                 default: true
    t.boolean  "active",                 default: true
    t.boolean  "inactivation_requested", default: false
  end

  add_index "courses", ["instructor_id"], name: "index_courses_on_instructor_id", using: :btree

  create_table "enrollment_requests", force: :cascade do |t|
    t.boolean  "is_fulfilled", default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "student_id"
    t.integer  "course_id"
  end

  add_index "enrollment_requests", ["course_id"], name: "index_enrollment_requests_on_course_id", using: :btree
  add_index "enrollment_requests", ["student_id"], name: "index_enrollment_requests_on_student_id", using: :btree

  create_table "grades", force: :cascade do |t|
    t.string   "gradeletter", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "history_id"
  end

  add_index "grades", ["history_id"], name: "index_grades_on_history_id", using: :btree

  create_table "histories", force: :cascade do |t|
    t.boolean  "is_current", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "course_id"
  end

  add_index "histories", ["course_id"], name: "index_histories_on_course_id", using: :btree
  add_index "histories", ["user_id"], name: "index_histories_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "instructor_id"
    t.integer  "student_id"
    t.string   "subject"
  end

  add_index "messages", ["instructor_id"], name: "index_messages_on_instructor_id", using: :btree
  add_index "messages", ["student_id"], name: "index_messages_on_student_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "content",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "message_id"
    t.integer  "user_id"
  end

  add_index "posts", ["message_id"], name: "index_posts_on_message_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "title",       null: false
    t.string   "description", null: false
    t.datetime "deadline",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "email",                          null: false
    t.string   "password_digest"
    t.string   "type"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "deletable",       default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "course_materials", "courses"
  add_foreign_key "course_materials", "tasks"
  add_foreign_key "courses", "users", column: "instructor_id"
  add_foreign_key "enrollment_requests", "courses"
  add_foreign_key "enrollment_requests", "users", column: "student_id"
  add_foreign_key "grades", "histories"
  add_foreign_key "histories", "courses"
  add_foreign_key "histories", "users"
  add_foreign_key "messages", "users", column: "instructor_id"
  add_foreign_key "messages", "users", column: "student_id"
  add_foreign_key "posts", "messages"
  add_foreign_key "posts", "users"
end
