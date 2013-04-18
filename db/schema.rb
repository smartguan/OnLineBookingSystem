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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130418012724) do

  create_table "registrations", :force => true do |t|
    t.integer  "waitlist_place"
    t.boolean  "payment_received"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "section_id"
    t.integer  "student_id"
  end

  create_table "sections", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "day"
    t.string   "teacher"
    t.integer  "enroll_cur"
    t.integer  "enroll_max"
    t.integer  "waitlist_cur"
    t.integer  "waitlist_max"
    t.string   "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.string   "section_type"
    t.string   "lesson_type"
    t.time     "start_time"
    t.time     "end_time"
  end

  create_table "users", :force => true do |t|
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.string   "dob"
    t.string   "zip"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "address"
    t.string   "city"
    t.string   "contact_one"
    t.string   "contact_one_primary"
    t.string   "contact_one_secondary"
    t.string   "contact_two"
    t.string   "contact_two_primary"
    t.string   "contact_two_secondary"
    t.string   "gender"
    t.string   "skill"
    t.string   "extra"
    t.integer  "access_code"
    t.string   "type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
