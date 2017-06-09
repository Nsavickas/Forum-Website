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

ActiveRecord::Schema.define(version: 20170609013153) do

  create_table "avatars", force: :cascade do |t|
    t.string   "displaypic_file_name",    limit: 255
    t.string   "displaypic_content_type", limit: 255
    t.integer  "displaypic_file_size",    limit: 4
    t.datetime "displaypic_updated_at"
    t.integer  "user_id",                 limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "avatars", ["user_id"], name: "index_avatars_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "comment_content", limit: 65535
    t.integer  "user_id",         limit: 4
    t.integer  "post_id",         limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "forums", force: :cascade do |t|
    t.string   "forumname",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "friender_id", limit: 4
    t.integer  "friended_id", limit: 4
    t.boolean  "accepted",              default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "friendships", ["friended_id"], name: "index_friendships_on_friended_id", using: :btree
  add_index "friendships", ["friender_id", "friended_id"], name: "index_friendships_on_friender_id_and_friended_id", unique: true, using: :btree
  add_index "friendships", ["friender_id"], name: "index_friendships_on_friender_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "itemname",    limit: 255
    t.string   "category",    limit: 255
    t.float    "price",       limit: 24
    t.text     "description", limit: 65535
    t.integer  "stock",       limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "items", ["user_id"], name: "index_items_on_user_id", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "likeable_id",   limit: 4
    t.string   "likeable_type", limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "likes", ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id", using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "notification_configurations", force: :cascade do |t|
    t.boolean  "notify_friendships",           default: true
    t.boolean  "notify_likes",                 default: true
    t.boolean  "notify_comments",              default: true
    t.integer  "user_id",            limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "notification_configurations", ["user_id"], name: "index_notification_configurations_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.boolean  "viewed",                      default: false
    t.integer  "user_id",         limit: 4
    t.integer  "notifiable_id",   limit: 4
    t.string   "notifiable_type", limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "notifications", ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.boolean  "default_image",                  default: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "imageable_id",       limit: 4
    t.string   "imageable_type",     limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "pictures", ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "postname",       limit: 255
    t.text     "content",        limit: 65535
    t.integer  "user_id",        limit: 4
    t.integer  "subforum_id",    limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "sticky",                       default: false
    t.integer  "likes_count",    limit: 4,     default: 0
    t.integer  "comments_count", limit: 4,     default: 0
  end

  add_index "posts", ["subforum_id"], name: "index_posts_on_subforum_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "subforums", force: :cascade do |t|
    t.string   "subforumname", limit: 255
    t.integer  "forum_id",     limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "admin_only",               default: true
  end

  add_index "subforums", ["forum_id"], name: "index_subforums_on_forum_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "email",             limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "password_digest",   limit: 255
    t.string   "remember_digest",   limit: 255
    t.boolean  "admin",                         default: false
    t.string   "activation_digest", limit: 255
    t.boolean  "activated",                     default: false
    t.datetime "activated_at"
    t.string   "reset_digest",      limit: 255
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
