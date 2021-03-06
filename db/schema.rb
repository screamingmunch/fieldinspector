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

ActiveRecord::Schema.define(:version => 20131215084311) do

  create_table "locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "project_name"
    t.integer  "zip"
    t.string   "risk_level"
    t.string   "contractor_name"
    t.string   "contractor_address"
    t.string   "contractor_contact_person"
    t.string   "contractor_contact_phone"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "locations_users", :force => true do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "photos", :force => true do |t|
    t.string   "image"
    t.integer  "report_id"
    t.integer  "user_id"
    t.string   "remote_image_url"
    t.boolean  "image_processed"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.date     "report_date"
    t.string   "report_type"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "profile_pic"
    t.string   "company"
    t.string   "title"
    t.string   "role"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
