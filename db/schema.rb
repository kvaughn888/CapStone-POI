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

ActiveRecord::Schema.define(version: 20140303225715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "user_id"
    t.string   "poi_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "subject"
    t.text     "body"
    t.string   "sender"
    t.string   "recipient"
    t.boolean  "has_read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pois", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "description"
    t.string   "title"
    t.integer  "user_id"
    t.string   "sponsor"
    t.integer  "total_ratings"
    t.integer  "total_people"
    t.integer  "avg_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "roles"
    t.string   "provider"
    t.string   "uid"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.integer  "phone1"
    t.integer  "phone2"
    t.integer  "phone3"
    t.integer  "age"
    t.string   "sex"
    t.string   "bio"
    t.string   "website"
    t.string   "remember_me"
    t.string   "password_reset_token"
    t.datetime "password_expires_after"
    t.string   "salt"
    t.boolean  "is_approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
