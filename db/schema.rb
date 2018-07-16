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

ActiveRecord::Schema.define(version: 20180716230742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "access_code_logs", force: true do |t|
    t.string   "access_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addon_sheets", force: true do |t|
    t.integer  "addon_id"
    t.integer  "order_package_id"
    t.integer  "index"
    t.integer  "senior_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "background_id"
  end

  create_table "addons", force: true do |t|
    t.string   "name"
    t.decimal  "price_with"
    t.decimal  "price_without"
    t.boolean  "popup"
    t.integer  "image_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "css_name"
  end

  create_table "autos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "failed_count"
    t.integer  "success_count"
  end

  create_table "award_info_students", force: true do |t|
    t.integer "student_id"
    t.integer "award_info_id"
    t.string  "trait"
  end

  create_table "award_infos", force: true do |t|
    t.string   "awarded_for"
    t.text     "definition"
    t.string   "time_period"
    t.date     "award_date"
    t.date     "receive_by"
    t.integer  "export_list_id"
    t.integer  "award_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "index"
    t.integer  "award_info_id"
    t.boolean  "processed",      default: false
  end

  create_table "award_infos_students", force: true do |t|
    t.integer "award_info_id"
    t.integer "student_id"
  end

  create_table "awards", force: true do |t|
    t.string   "title"
    t.string   "abbreviation"
    t.string   "awarded_for"
    t.string   "definition"
    t.string   "time_period"
    t.date     "award_date"
    t.integer  "export_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "recieve_by"
    t.boolean  "add_period"
    t.boolean  "add_date"
    t.boolean  "submitted"
    t.integer  "school_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "add_awarded_for",    default: false
    t.boolean  "add_definition",     default: false
    t.boolean  "trait_definition"
  end

  create_table "backgrounds", force: true do |t|
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "hidden",             default: false
  end

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
    t.boolean  "download"
    t.boolean  "product"
    t.boolean  "both"
  end

  create_table "cart_students", force: true do |t|
    t.integer "student_id"
    t.integer "cart_id"
    t.integer "i"
  end

  create_table "cart_teams", force: true do |t|
    t.integer  "cart_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "email"
    t.string   "shoob_id"
    t.integer  "zip_code"
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
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "package_type"
    t.integer  "order_number"
    t.string   "photo_type"
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
    t.string   "grade"
    t.boolean  "residential"
  end

  create_table "dattachments", force: true do |t|
    t.integer  "dproject_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project_attachment_file_name"
    t.string   "project_attachment_content_type"
    t.integer  "project_attachment_file_size"
    t.datetime "project_attachment_updated_at"
  end

  create_table "districts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "last",       default: false
  end

  create_table "download_images", force: true do |t|
    t.integer  "package_id"
    t.integer  "student_id"
    t.string   "folder"
    t.string   "url"
    t.string   "shoob_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "year"
    t.string   "watermark_file_name"
    t.string   "watermark_content_type"
    t.integer  "watermark_file_size"
    t.datetime "watermark_updated_at"
  end

  create_table "dprojects", force: true do |t|
    t.string   "scode"
    t.datetime "completed_at"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "requested_by"
    t.string   "assigned_to"
    t.integer  "order_num"
    t.string   "contact"
    t.string   "contact_email"
    t.string   "ptype"
    t.datetime "due_date"
    t.datetime "must_date"
    t.datetime "print_date"
    t.datetime "proofs_out"
    t.datetime "proofs_in"
    t.string   "status"
    t.string   "delivery_type"
    t.string   "route"
    t.datetime "delivery_date"
    t.string   "tracking_number"
    t.string   "shipping_instructions"
    t.boolean  "delivered"
    t.text     "printing_instructions"
    t.text     "project_changes"
    t.text     "project_path"
    t.string   "project_type"
    t.string   "assigned_by"
    t.text     "design_instructions"
    t.string   "dfile_file_name"
    t.string   "dfile_content_type"
    t.integer  "dfile_file_size"
    t.datetime "dfile_updated_at"
    t.integer  "school_id"
    t.datetime "invoice_date"
    t.string   "invoice_addressee"
    t.text     "invoice_description"
    t.decimal  "invoice_subtotal"
    t.decimal  "invoice_credit"
    t.decimal  "invoice_shipping"
    t.decimal  "invoice_sales_tax"
    t.decimal  "invoice_total"
    t.decimal  "invoice_paid"
    t.datetime "invoice_payment_date"
    t.text     "invoice_notes"
    t.boolean  "invoice_bool"
  end

  create_table "dschools", force: true do |t|
    t.string   "scode"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educators", force: true do |t|
    t.integer  "school_id"
    t.integer  "scode"
    t.string   "name"
    t.string   "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.integer  "teacher_id"
    t.string   "email"
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
    t.integer  "award_id"
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
    t.string   "uniq_id"
    t.integer  "award_id"
    t.boolean  "multiple",       default: false
    t.integer  "export_list_id"
    t.boolean  "correction",     default: false
    t.boolean  "hidden",         default: false
    t.date     "submit_date"
  end

  create_table "exports", force: true do |t|
    t.text     "file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "file_path_setup"
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

  create_table "favorites", force: true do |t|
    t.integer  "order_package_id"
    t.integer  "package_id"
    t.integer  "senior_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "permanent"
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

  create_table "gifts", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "number"
    t.boolean  "download"
  end

  create_table "headshot_photos", force: true do |t|
    t.string   "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "capturable_id"
    t.string   "capturable_type"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "package_id"
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
    t.string   "size"
    t.string   "product_type"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.string   "format"
  end

  create_table "jobs", force: true do |t|
    t.integer  "scode"
    t.string   "account"
    t.date     "date"
    t.string   "job"
    t.string   "jobtype"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lineitems", force: true do |t|
    t.integer  "dproject_id"
    t.integer  "quantity"
    t.integer  "product_code"
    t.string   "product"
    t.decimal  "price"
    t.decimal  "extended_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missings", force: true do |t|
    t.string   "file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "school_id"
  end

  create_table "option_carts", force: true do |t|
    t.integer  "order_package_id"
    t.integer  "option_id"
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
    t.boolean  "download"
    t.integer  "poses"
    t.boolean  "without",       default: false
  end

  create_table "order_package_extras", force: true do |t|
    t.integer  "order_package_id"
    t.integer  "extra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "option_id"
  end

  create_table "order_package_gifts", force: true do |t|
    t.integer  "order_package_id"
    t.integer  "gift_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_packages", force: true do |t|
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cart_id"
    t.integer  "option_id"
    t.boolean  "email_picture",     default: false
    t.integer  "student_id"
    t.string   "url"
    t.string   "pose"
    t.integer  "download_image_id"
    t.string   "grad"
    t.integer  "extra_poses",       default: 0
    t.integer  "senior_image_id"
    t.integer  "student_image_id"
    t.integer  "quantity"
    t.boolean  "email_sent"
    t.integer  "background_id"
    t.boolean  "scanned",           default: false
    t.boolean  "qualified",         default: false
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
    t.boolean  "processed",           default: false
    t.text     "notes"
    t.integer  "school_id"
    t.boolean  "posted",              default: false
    t.boolean  "free",                default: false
    t.string   "shipping_first_name"
    t.string   "shipping_last_name"
    t.string   "address2"
    t.string   "shipping_address2"
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
    t.boolean  "hidden",              default: false
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

  create_table "payment_notifications", force: true do |t|
    t.text     "params"
    t.string   "status"
    t.string   "transaction_id"
    t.integer  "cart_id"
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

  create_table "porders", force: true do |t|
    t.integer  "project_id"
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
    t.boolean  "processed"
    t.date     "card_expires_on"
    t.string   "purchase_order"
    t.boolean  "free"
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

  create_table "print_sizes", force: true do |t|
    t.string   "size"
    t.integer  "price"
    t.integer  "print_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "print_styles", force: true do |t|
    t.string   "style"
    t.integer  "price"
    t.integer  "print_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prints", force: true do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "price_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "project_prints", force: true do |t|
    t.integer  "project_id"
    t.integer  "print_id"
    t.integer  "quantity"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.date     "delivery"
    t.boolean  "flexible"
    t.integer  "print_size_id"
    t.integer  "print_style_id"
  end

  create_table "projects", force: true do |t|
    t.string   "school"
    t.string   "email"
    t.string   "position"
    t.string   "phone"
    t.date     "delivery"
    t.boolean  "flexible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "school_exports", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
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
    t.boolean  "default",           default: false
    t.integer  "school_type_id"
    t.boolean  "teacher",           default: false
    t.string   "ca_code"
    t.integer  "district_id"
    t.integer  "city_id"
    t.string   "address"
    t.string   "phone"
    t.string   "principal"
    t.string   "secretary"
    t.string   "cdscode"
    t.boolean  "visible",           default: false
    t.text     "student_cache"
    t.text     "yearbook_cache"
    t.boolean  "multiple",          default: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "scode"
    t.boolean  "enrolled",          default: false
    t.boolean  "clear_teachers"
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
    t.integer  "order_id"
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

  create_table "senior_images", force: true do |t|
    t.integer  "student_image_id"
    t.string   "url"
    t.integer  "index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "watermark_file_name"
    t.string   "watermark_content_type"
    t.integer  "watermark_file_size"
    t.datetime "watermark_updated_at"
    t.string   "extension",              default: ".jpg"
  end

  create_table "sheets", force: true do |t|
    t.integer  "senior_image_id"
    t.integer  "order_package_id"
    t.integer  "image_type_id"
    t.integer  "index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "background_id"
  end

  create_table "shippings", force: true do |t|
    t.decimal  "price"
    t.integer  "school_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sizes", force: true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "print_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_errors", force: true do |t|
    t.integer  "auto_id"
    t.text     "error_text"
    t.string   "error_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
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
    t.boolean  "downloaded",             default: false
    t.string   "watermark_file_name"
    t.string   "watermark_content_type"
    t.integer  "watermark_file_size"
    t.datetime "watermark_updated_at"
    t.string   "shoob_id"
    t.string   "load_id"
    t.string   "accesscode"
    t.string   "extension",              default: ".jpg"
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
    t.integer  "user_id"
    t.boolean  "webcam",             default: false
    t.string   "access_code"
    t.boolean  "enrolled",           default: false
    t.string   "lower_teacher"
    t.integer  "educator_id"
  end

  create_table "subcategories", force: true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "student_id"
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

  create_table "tests", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "award_id"
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
    t.boolean  "developer"
    t.boolean  "photographer"
    t.boolean  "employee"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "webcams", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "yearbooks", force: true do |t|
    t.date     "date"
    t.integer  "quantity"
    t.decimal  "amount"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.string   "payment_type"
    t.string   "sold_by"
    t.integer  "user_id"
  end

  create_table "zipcodes", force: true do |t|
    t.integer  "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
