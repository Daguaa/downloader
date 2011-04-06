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

ActiveRecord::Schema.define(:version => 20110406020454) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "delayed_jobs_locked_by"
  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "remote_files", :force => true do |t|
    t.string   "original_name"
    t.integer  "site_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size"
    t.integer  "downloaded"
    t.string   "name"
  end

  create_table "sites", :force => true do |t|
    t.string   "url"
    t.string   "login"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
