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

ActiveRecord::Schema.define(version: 20131014080729) do

  create_table "assets", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "source_path"
    t.string   "file_path",                   null: false
    t.string   "file_name",                   null: false
    t.integer  "size",            default: 0, null: false
    t.integer  "state",           default: 1, null: false
    t.integer  "sort",            default: 0, null: false
    t.integer  "kind",            default: 1, null: false
    t.integer  "width",           default: 0, null: false
    t.integer  "height",          default: 0, null: false
    t.string   "format_type",                 null: false
    t.integer  "relateable_id"
    t.string   "relateable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["kind"], name: "index_assets_on_kind", using: :btree
  add_index "assets", ["name"], name: "index_assets_on_name", using: :btree
  add_index "assets", ["relateable_id"], name: "index_assets_on_relateable_id", using: :btree
  add_index "assets", ["relateable_type"], name: "index_assets_on_relateable_type", using: :btree
  add_index "assets", ["size"], name: "index_assets_on_size", using: :btree
  add_index "assets", ["sort"], name: "index_assets_on_sort", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",                    null: false
    t.string   "description"
    t.string   "mark"
    t.integer  "user_id",                 null: false
    t.integer  "kind",        default: 1, null: false
    t.integer  "state",       default: 1, null: false
    t.integer  "stick",       default: 0, null: false
    t.integer  "pid",         default: 0, null: false
    t.integer  "sort",        default: 0, null: false
    t.integer  "count",       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["kind"], name: "index_categories_on_kind", using: :btree
  add_index "categories", ["mark"], name: "index_categories_on_mark", using: :btree
  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree
  add_index "categories", ["pid"], name: "index_categories_on_pid", using: :btree
  add_index "categories", ["sort"], name: "index_categories_on_sort", using: :btree
  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title",                   null: false
    t.text     "description"
    t.text     "content"
    t.string   "tags"
    t.integer  "user_id",                 null: false
    t.integer  "kind",        default: 1, null: false
    t.integer  "category_id",             null: false
    t.integer  "state",       default: 1, null: false
    t.integer  "publish",     default: 1, null: false
    t.integer  "view_count",  default: 0, null: false
    t.integer  "stick",       default: 0, null: false
    t.integer  "sort",        default: 0, null: false
    t.integer  "cover_id",    default: 0, null: false
    t.integer  "deleted",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["category_id"], name: "index_posts_on_category_id", using: :btree
  add_index "posts", ["cover_id"], name: "index_posts_on_cover_id", using: :btree
  add_index "posts", ["kind"], name: "index_posts_on_kind", using: :btree
  add_index "posts", ["sort"], name: "index_posts_on_sort", using: :btree
  add_index "posts", ["title"], name: "index_posts_on_title", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree
  add_index "posts", ["view_count"], name: "index_posts_on_view_count", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                        null: false
    t.string   "email",                       null: false
    t.text     "description"
    t.integer  "state",           default: 1, null: false
    t.integer  "kind",            default: 1, null: false
    t.integer  "role_id",         default: 1, null: false
    t.integer  "sex",             default: 0, null: false
    t.string   "ip"
    t.datetime "last_time"
    t.string   "remember_token"
    t.string   "password_digest"
    t.string   "avatar_path"
    t.string   "avatar_format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["avatar_path"], name: "index_users_on_avatar_path", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["kind"], name: "index_users_on_kind", using: :btree
  add_index "users", ["last_time"], name: "index_users_on_last_time", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

end
