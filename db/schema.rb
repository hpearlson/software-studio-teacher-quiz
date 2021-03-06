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

ActiveRecord::Schema.define(version: 20171216014850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "course_name"
    t.integer  "teacher_id"
    t.integer  "true_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "generatedID"
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "description"
    t.boolean  "is_correct"
    t.integer  "course_id"
    t.integer  "true_id",                limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "generatedID"
    t.string   "email_address"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "quiz_score"
    t.integer  "quiz_score_day_updated"
    t.integer  "roundNumber"
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "description"
    t.string   "password_digest"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_address"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

end
