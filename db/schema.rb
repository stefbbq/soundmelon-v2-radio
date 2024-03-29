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

ActiveRecord::Schema.define(:version => 20141116170947) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "artists", :force => true do |t|
    t.string   "artist_name"
    t.integer  "user_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.text     "youtube_token"
    t.text     "soundcloud_token"
    t.string   "artist_photo_file_name"
    t.string   "artist_photo_content_type"
    t.integer  "artist_photo_file_size"
    t.datetime "artist_photo_updated_at"
    t.string   "website"
    t.text     "genre_tags"
    t.string   "city"
    t.text     "facebook_link"
    t.text     "twitter_link"
    t.text     "itunes_link"
    t.boolean  "first_song_added",          :default => false
    t.boolean  "profile_edited",            :default => false
    t.text     "city_coords"
  end

  create_table "blocked_uploads", :force => true do |t|
    t.string   "upload_source"
    t.string   "song_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "email"
    t.string   "title"
    t.text     "content"
    t.boolean  "open",       :default => true
    t.string   "status"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "category"
  end

  create_table "invites", :force => true do |t|
    t.string   "email"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "token"
  end

  create_table "reports", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.integer  "user_id"
    t.string   "reportable_type"
    t.string   "reportable_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "open",            :default => true
    t.string   "resolution"
  end

  create_table "songs", :force => true do |t|
    t.integer  "artist_id"
    t.string   "song_id"
    t.text     "sm_tags"
    t.boolean  "active",        :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "upload_source"
    t.string   "song_url"
    t.boolean  "is_private"
    t.boolean  "blocked",       :default => false
    t.text     "source_tags"
    t.string   "song_title"
    t.string   "duration"
    t.string   "song_image"
    t.string   "slug"
  end

  add_index "songs", ["slug"], :name => "index_songs_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email"
    t.string   "city"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_digest"
    t.string   "email_confirmation"
    t.string   "remember_token"
    t.boolean  "is_artist",              :default => false
    t.integer  "artist_id"
    t.text     "fb_meta"
    t.string   "provider"
    t.string   "uid"
    t.text     "oauth_token"
    t.boolean  "terms",                  :default => false
    t.boolean  "custom_city",            :default => false
    t.text     "user_meta"
    t.text     "song_history"
    t.text     "invites"
    t.text     "city_coords"
    t.text     "favorite_songs"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "encrypted_password"
    t.boolean  "guest",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
