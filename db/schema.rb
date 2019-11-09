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

ActiveRecord::Schema.define(version: 20191104084257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "followreqs", force: :cascade do |t|
    t.integer "userReq"
    t.integer "target"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower"
    t.integer "followed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hash_tags", force: :cascade do |t|
    t.string "name"
    t.integer "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "author"
    t.integer "target"
    t.string "target_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "multimedia", force: :cascade do |t|
    t.integer "owner"
    t.string "url"
    t.string "type"
    t.boolean "privacy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ptags", force: :cascade do |t|
    t.integer "author"
    t.integer "target"
    t.string "tag_type"
    t.integer "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publications", force: :cascade do |t|
    t.boolean "private"
    t.integer "author"
    t.string "text"
    t.string "content_url"
    t.string "tags"
    t.string "hashtags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ptype"
  end

  create_table "stories", force: :cascade do |t|
    t.integer "author"
    t.boolean "private"
    t.string "text"
    t.string "content_url"
    t.string "hashtags"
    t.string "ptype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bcolor"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "verify"
    t.date "birthdate"
    t.string "name"
    t.string "lastname"
    t.string "nickname"
    t.string "email"
    t.string "country"
    t.string "city"
    t.string "password"
    t.string "profile_pic"
    t.string "description"
    t.boolean "private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "verifies", force: :cascade do |t|
    t.string "code"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
