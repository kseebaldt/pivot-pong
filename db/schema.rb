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

ActiveRecord::Schema.define(version: 20170131004242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "title",       limit: 255
    t.text     "description"
    t.string   "badge",       limit: 255
    t.string   "type",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "match_id"
  end

  create_table "daily_logs", force: :cascade do |t|
    t.float    "average_games_per_player"
    t.integer  "match_count"
    t.date     "date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "match_id"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "occured_at"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "occured_at"
    t.integer  "winner_id"
    t.integer  "loser_id"
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "rank"
    t.boolean  "active",                 default: true
    t.string   "avatar",     limit: 255
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "site_settings", force: :cascade do |t|
    t.string   "setting_type", limit: 255
    t.string   "value",        limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "totems", force: :cascade do |t|
    t.integer "player_id"
    t.integer "loser_id"
  end

end
