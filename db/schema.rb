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

ActiveRecord::Schema.define(version: 20160112103118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

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

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "columns", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "column_type"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "school"
    t.string   "student"
    t.string   "grade"
    t.string   "teacher_name"
    t.string   "address"
    t.string   "city"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.boolean  "admin"
    t.boolean  "teacher"
    t.boolean  "parent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "jobseeker"
  end

  create_table "corders", force: true do |t|
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
    t.decimal  "price"
    t.string   "shipping_address"
    t.string   "shipping_city"
    t.string   "shipping_zip"
    t.string   "shipping_state"
    t.boolean  "processed",        default: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "card_expires_on"
    t.boolean  "free"
    t.string   "schools"
    t.boolean  "admin"
    t.boolean  "teacher"
    t.boolean  "parent"
    t.string   "district"
  end

  create_table "districts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "last",       default: false
  end

  create_table "export_data", force: true do |t|
    t.text     "kind"
    t.integer  "type_id"
    t.string   "prompt_values"
    t.string   "sort_by"
    t.string   "certificate_title"
    t.string   "distribution_date"
    t.string   "additional_information"
    t.integer  "user_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.string   "file_file_size"
    t.string   "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_id"
  end

  create_table "export_data_students", force: true do |t|
    t.integer  "student_id"
    t.integer  "export_data_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "export_list_items", force: true do |t|
    t.integer  "user_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "export_list_students", force: true do |t|
    t.integer  "student_id"
    t.integer  "export_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "export_lists", force: true do |t|
    t.integer  "user_id"
    t.boolean  "submitted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "name"
    t.date     "date"
    t.date     "delivery"
    t.string   "school"
    t.string   "data"
    t.text     "file_path"
    t.integer  "school_id"
  end

  create_table "exports", force: true do |t|
    t.text     "file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "fields", force: true do |t|
    t.integer  "x"
    t.integer  "y"
    t.integer  "width"
    t.integer  "height"
    t.string   "align"
    t.string   "column_name"
    t.integer  "template_id"
    t.string   "font"
    t.integer  "font_id"
    t.integer  "text_size"
    t.string   "color"
    t.integer  "spacing"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "column_id"
  end

  create_table "fonts", force: true do |t|
    t.string   "name"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.string   "file_file_size"
    t.string   "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "item_categories", force: true do |t|
    t.integer  "item_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.text     "name"
    t.decimal  "price"
    t.boolean  "per_page"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.string   "number"
    t.string   "main_file_name"
    t.string   "main_content_type"
    t.integer  "main_file_size"
    t.datetime "main_updated_at"
    t.integer  "subcategory_id"
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

  create_table "notes", force: true do |t|
    t.integer  "school_note_id"
    t.text     "note"
    t.text     "action"
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "option_packages", force: true do |t|
    t.integer  "option_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "package_id"
    t.string   "slug"
    t.boolean  "email_picture", default: false
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
    t.string   "url"
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
    t.boolean  "multiple",            default: false
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

  create_table "pdfs", force: true do |t|
    t.string   "name"
    t.string   "file_file_name"
    t.string   "file_file_size"
    t.string   "file_content_type"
    t.string   "file_updated_at"
    t.string   "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periods", force: true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", force: true do |t|
    t.decimal  "price"
    t.integer  "school_id"
    t.date     "begin"
    t.date     "enddate"
    t.integer  "option_id"
    t.integer  "extra_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_notes", force: true do |t|
    t.string   "name"
    t.integer  "district_id"
    t.integer  "city_id"
    t.string   "address"
    t.string   "phone"
    t.string   "principal"
    t.string   "secretary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cdscode"
  end

  create_table "school_packages", id: false, force: true do |t|
    t.integer "package_id"
    t.integer "school_id"
  end

  create_table "school_templates", id: false, force: true do |t|
    t.integer "school_id"
    t.integer "type_id"
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
    t.string   "ca_code"
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

  create_table "searchterm_items", force: true do |t|
    t.integer  "item_id"
    t.integer  "searchterm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searchterms", force: true do |t|
    t.string   "name"
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
    t.string   "index_file_name"
    t.string   "index_content_type"
    t.integer  "index_file_size"
    t.datetime "index_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "url2"
    t.string   "url3"
    t.string   "url4"
    t.string   "url1"
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
    t.string   "student_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "grade"
    t.string   "email"
    t.integer  "school_id"
    t.date     "dob"
    t.string   "teacher"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "shoob_id"
    t.boolean  "id_only",            default: false
    t.string   "data1"
    t.string   "data2"
    t.string   "data3"
    t.string   "data4"
    t.integer  "period_id"
  end

  create_table "subcategories", force: true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_columns", force: true do |t|
    t.integer  "column_id"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "export_data_id"
  end

  create_table "types", force: true do |t|
    t.string   "name"
    t.integer  "pdf_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "preview",    default: false
  end

  create_table "user_students", force: true do |t|
    t.integer  "user_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "school_id"
    t.boolean  "school_admin",           default: false
    t.boolean  "principal",              default: false
    t.boolean  "teacher",                default: false
    t.boolean  "secretary",              default: false
    t.boolean  "parent",                 default: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "yearbooks", force: true do |t|
    t.date     "date"
    t.integer  "quantity"
    t.decimal  "amount"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.string   "payment_type"
  end

end
