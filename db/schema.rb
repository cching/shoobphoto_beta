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

ActiveRecord::Schema.define(version: 20150818080115) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banners", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "school_type_id"
  end

  create_table "cart_items", force: true do |t|
    t.integer  "cart_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pages"
    t.integer  "quantity",   default: 1
  end

  create_table "cart_students", force: true do |t|
    t.integer "student_id"
    t.integer "cart_id"
  end

  create_table "carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cart_id"
    t.boolean  "processed",   default: false
    t.decimal  "price"
    t.boolean  "purchased",   default: false
    t.string   "cart_type"
    t.integer  "school_id"
    t.boolean  "id_supplied", default: true
  end

  create_table "extra_assignments", force: true do |t|
    t.integer  "option_id"
    t.integer  "extra_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extra_types", force: true do |t|
    t.string   "name"
    t.boolean  "required"
    t.boolean  "multiple"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extras", force: true do |t|
    t.string   "name"
    t.integer  "extra_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "quantity"
  end

  create_table "image_types", force: true do |t|
    t.string   "name"
    t.string   "option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.text     "url"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.text    "name"
    t.decimal "price"
    t.string  "item_id"
    t.boolean "per_page"
  end

  create_table "nav_links", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",         precision: 8, scale: 2
    t.integer  "package_id"
    t.string   "slug"
    t.boolean  "email_picture",                         default: false
  end

  create_table "order_package_extras", force: true do |t|
    t.integer  "order_package_id"
    t.integer  "extra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_packages", force: true do |t|
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cart_id"
    t.integer  "option_id"
    t.boolean  "email_picture", default: false
    t.integer  "student_id"
  end

  create_table "orders", force: true do |t|
    t.integer  "cart_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "shipping_address"
    t.string   "shipping_city"
    t.string   "shipping_zip"
    t.string   "shipping_state"
    t.boolean  "processed",        default: false
    t.text     "notes"
    t.integer  "school_id"
    t.boolean  "posted",           default: false
  end

  create_table "packages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "default_url"
    t.string   "default_folder"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "slug"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "slug"
    t.integer  "lft",        null: false
    t.integer  "rgt",        null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", force: true do |t|
    t.decimal  "price"
    t.integer  "school_id"
    t.date     "begin"
    t.date     "end"
    t.integer  "option_id"
    t.integer  "extra_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_packages", id: false, force: true do |t|
    t.integer "package_id"
    t.integer "school_id"
  end

  create_table "school_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default",        default: false
    t.integer  "school_type_id"
    t.boolean  "teacher",        default: false
  end

  create_table "searches", force: true do |t|
    t.string   "student_first_name"
    t.string   "student_last_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "school_id"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.string   "card_type"
    t.string   "state"
    t.string   "zip"
    t.string   "billing_address"
    t.string   "billing_zip"
    t.string   "city"
    t.string   "billing_city"
    t.boolean  "processed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shippings", force: true do |t|
    t.decimal  "price"
    t.integer  "school_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_images", force: true do |t|
    t.integer  "package_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.string   "grade"
    t.string   "folder"
  end

  create_table "student_proofs", force: true do |t|
    t.integer  "package_id"
    t.integer  "student_id"
    t.string   "url"
    t.string   "grade"
    t.string   "folder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.integer "district_id"
    t.string  "student_id"
    t.string  "last_name"
    t.string  "first_name"
    t.string  "grade"
    t.string  "email"
    t.integer "school_id"
    t.date    "dob"
    t.string  "teacher"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
