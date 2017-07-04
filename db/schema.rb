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

ActiveRecord::Schema.define(:version => 20150428045943) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "roles"
    t.string   "name"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "bids", :force => true do |t|
    t.float    "total"
    t.text     "message"
    t.datetime "bid_date"
    t.integer  "tender_id"
    t.integer  "customer_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "no_of_parcels"
    t.integer  "stone_id"
    t.float    "price_per_carat"
  end

  add_index "bids", ["customer_id"], :name => "index_bids_on_customer_id"
  add_index "bids", ["stone_id"], :name => "index_bids_on_stone_id"
  add_index "bids", ["tender_id"], :name => "index_bids_on_tender_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "address"
    t.string   "country"
    t.string   "email"
    t.integer  "registration_vat_no"
    t.string   "registration_no"
    t.string   "fax"
    t.string   "telephone"
    t.integer  "mobile"
  end

  create_table "contact_people", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "designation", :null => false
    t.integer  "company_id"
    t.string   "telephone"
    t.integer  "mobile"
    t.string   "passport_no"
    t.string   "pio_card"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "customers", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "address"
    t.string   "postal_code"
    t.string   "phone"
    t.boolean  "status"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "company"
    t.text     "company_address"
    t.string   "phone_2"
    t.string   "mobile_no"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "customers", ["email"], :name => "index_customers_on_email", :unique => true
  add_index "customers", ["invitation_token"], :name => "index_customers_on_invitation_token", :unique => true
  add_index "customers", ["invited_by_id"], :name => "index_customers_on_invited_by_id"
  add_index "customers", ["reset_password_token"], :name => "index_customers_on_reset_password_token", :unique => true

  create_table "customers_tenders", :force => true do |t|
    t.integer  "tender_id"
    t.integer  "customer_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "confirmed",   :default => false
  end

  add_index "customers_tenders", ["customer_id"], :name => "index_customers_tenders_on_customer_id"
  add_index "customers_tenders", ["tender_id"], :name => "index_customers_tenders_on_tender_id"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "url"
    t.datetime "date"
    t.string   "category"
    t.text     "description"
    t.boolean  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "notes", :force => true do |t|
    t.integer  "tender_id"
    t.integer  "customer_id"
    t.string   "key"
    t.text     "note"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "stone_id"
    t.string   "deec_no"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "ratings", :force => true do |t|
    t.integer  "tender_id"
    t.integer  "customer_id"
    t.string   "key"
    t.integer  "score"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "flag_type",   :default => "Imp"
  end

  create_table "stones", :force => true do |t|
    t.string   "stone_type"
    t.integer  "no_of_stones"
    t.float    "size"
    t.float    "weight"
    t.decimal  "carat",        :precision => 10, :scale => 5
    t.float    "purity"
    t.string   "color"
    t.boolean  "polished"
    t.integer  "tender_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "deec_no"
    t.integer  "lot_no"
    t.text     "description"
  end

  add_index "stones", ["tender_id"], :name => "index_stones_on_tender_id"

  create_table "temp_stones", :force => true do |t|
    t.integer  "tender_id"
    t.integer  "lot_no"
    t.string   "description"
    t.integer  "no_of_stones"
    t.float    "carat"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tender_winners", :force => true do |t|
    t.integer  "tender_id"
    t.integer  "lot_no"
    t.string   "selling_price"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "description"
    t.float    "avg_selling_price"
  end

  add_index "tender_winners", ["tender_id"], :name => "index_tender_winners_on_tender_id"

  create_table "tenders", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "open_date"
    t.datetime "close_date"
    t.boolean  "tender_open"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.boolean  "send_confirmation"
    t.string   "winner_list_file_name"
    t.string   "winner_list_content_type"
    t.integer  "winner_list_file_size"
    t.datetime "winner_list_updated_at"
    t.string   "temp_document_file_name"
    t.string   "temp_document_content_type"
    t.integer  "temp_document_file_size"
    t.datetime "temp_document_updated_at"
    t.integer  "company_id"
    t.string   "deec_no_field"
    t.string   "lot_no_field"
    t.string   "desc_field"
    t.string   "no_of_stones_field"
    t.string   "weight_field"
    t.integer  "sheet_no"
    t.string   "winner_lot_no_field"
    t.string   "winner_desc_field"
    t.string   "winner_no_of_stones_field"
    t.string   "winner_weight_field"
    t.string   "winner_selling_price_field"
    t.string   "winner_carat_selling_price_field"
    t.integer  "winner_sheet_no"
    t.integer  "reference_id"
  end

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.integer  "reverted_from"
    t.string   "tag"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "object_changes"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

  create_table "winners", :force => true do |t|
    t.integer  "tender_id"
    t.integer  "customer_id"
    t.integer  "bid_id"
    t.integer  "stone_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "winners", ["bid_id"], :name => "index_winners_on_bid_id"
  add_index "winners", ["customer_id"], :name => "index_winners_on_customer_id"
  add_index "winners", ["stone_id"], :name => "index_winners_on_stone_id"
  add_index "winners", ["tender_id"], :name => "index_winners_on_tender_id"

end
