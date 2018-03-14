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

ActiveRecord::Schema.define(version: 20180314122943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "roles"
    t.string "name"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "auction_rounds", force: :cascade do |t|
    t.integer "round_no"
    t.float "min_bid"
    t.float "max_bid"
    t.integer "auction_id"
    t.datetime "started_at"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auctions", force: :cascade do |t|
    t.datetime "time"
    t.float "min_bid"
    t.integer "tender_id"
    t.integer "round_time"
    t.boolean "started", default: false
    t.boolean "completed", default: false
    t.integer "loosers_per_round"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "evaluating_round_id"
  end

  create_table "bid_calculations", force: :cascade do |t|
    t.integer "stone_id"
    t.integer "customer_id"
    t.boolean "responce"
    t.integer "round"
    t.float "system_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bids", force: :cascade do |t|
    t.float "total"
    t.text "message"
    t.datetime "bid_date"
    t.bigint "tender_id"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "no_of_parcels"
    t.integer "stone_id"
    t.float "price_per_carat"
    t.integer "auction_round_id"
    t.integer "sight_id"
    t.integer "percentage_over_cost"
    t.index ["customer_id"], name: "index_bids_on_customer_id"
    t.index ["tender_id"], name: "index_bids_on_tender_id"
  end

  create_table "block_users", force: :cascade do |t|
    t.integer "customer_id"
    t.string "block_user_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "broker_invites", force: :cascade do |t|
    t.string "email"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "broker_requests", force: :cascade do |t|
    t.integer "broker_id"
    t.integer "seller_id"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "country"
    t.string "email"
    t.integer "registration_vat_no"
    t.string "registration_no"
    t.string "fax"
    t.string "telephone"
    t.integer "mobile"
    t.string "status"
    t.integer "integer"
    t.integer "customer_id"
    t.integer "parent_id"
    t.integer "credit_limit"
    t.integer "market_limit"
  end

  create_table "contact_people", force: :cascade do |t|
    t.string "name", null: false
    t.string "designation", null: false
    t.integer "company_id"
    t.string "telephone"
    t.integer "mobile"
    t.string "passport_no"
    t.string "pio_card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_limits", force: :cascade do |t|
    t.integer "supplier_id"
    t.integer "buyer_id"
    t.decimal "credit_limit"
    t.decimal "market_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "reference_id"
  end

  create_table "customer_comments", force: :cascade do |t|
    t.text "description"
    t.bigint "customer_id"
    t.bigint "tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stone_id"
    t.index ["customer_id"], name: "index_customer_comments_on_customer_id"
    t.index ["stone_id"], name: "index_customer_comments_on_stone_id"
    t.index ["tender_id"], name: "index_customer_comments_on_tender_id"
  end

  create_table "customer_notifications", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "notification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_customer_notifications_on_customer_id"
    t.index ["notification_id"], name: "index_customer_notifications_on_notification_id"
  end

  create_table "customer_pictures", force: :cascade do |t|
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
    t.bigint "customer_id"
    t.bigint "tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stone_id"
    t.index ["customer_id"], name: "index_customer_pictures_on_customer_id"
    t.index ["stone_id"], name: "index_customer_pictures_on_stone_id"
    t.index ["tender_id"], name: "index_customer_pictures_on_tender_id"
  end

  create_table "customer_ratings", force: :cascade do |t|
    t.integer "star"
    t.bigint "customer_id"
    t.bigint "tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stone_id"
    t.index ["customer_id"], name: "index_customer_ratings_on_customer_id"
    t.index ["stone_id"], name: "index_customer_ratings_on_stone_id"
    t.index ["tender_id"], name: "index_customer_ratings_on_tender_id"
  end

  create_table "customer_roles", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "address"
    t.string "postal_code"
    t.string "phone"
    t.boolean "status"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "company"
    t.text "company_address"
    t.string "phone_2"
    t.string "mobile_no"
    t.string "authentication_token"
    t.boolean "verified", default: false
    t.string "certificate_file_name"
    t.string "certificate_content_type"
    t.integer "certificate_file_size"
    t.datetime "certificate_updated_at"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "chat_id", default: "-1"
    t.string "firebase_uid"
    t.integer "parent_id"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["invitation_token"], name: "index_customers_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_customers_on_invitations_count"
    t.index ["invited_by_id"], name: "index_customers_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_customers_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "customers_tenders", force: :cascade do |t|
    t.bigint "tender_id"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed", default: false
    t.index ["customer_id"], name: "index_customers_tenders_on_customer_id"
    t.index ["tender_id"], name: "index_customers_tenders_on_tender_id"
  end

  create_table "days_limits", force: :cascade do |t|
    t.integer "supplier_id"
    t.integer "buyer_id"
    t.decimal "days_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "demand_lists", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "demand_supplier_id"
  end

  create_table "demand_suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "diamond_type"
  end

  create_table "demands", force: :cascade do |t|
    t.string "description"
    t.float "weight"
    t.float "price"
    t.bigint "customer_id"
    t.string "diamond_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "demand_supplier_id"
    t.boolean "block"
    t.boolean "deleted"
    t.index ["customer_id"], name: "index_demands_on_customer_id"
  end

  create_table "devices", force: :cascade do |t|
    t.integer "customer_id"
    t.string "token"
    t.string "device_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_attachments", force: :cascade do |t|
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "customer_id"
    t.integer "tender_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.string "message"
    t.string "message_type"
    t.string "subject"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "news", force: :cascade do |t|
    t.string "title"
    t.text "url"
    t.datetime "date"
    t.string "category"
    t.text "description"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer "tender_id"
    t.integer "customer_id"
    t.string "key"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stone_id"
    t.string "deec_no"
    t.integer "sight_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "tender_id"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_notifications_on_customer_id"
    t.index ["tender_id"], name: "index_notifications_on_tender_id"
  end

  create_table "parcel_images", force: :cascade do |t|
    t.integer "parcel_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "customer_id"
    t.string "image_url"
  end

  create_table "parcel_size_infos", force: :cascade do |t|
    t.string "carats"
    t.string "size"
    t.string "percent"
    t.integer "trading_parcel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partial_payments", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "transaction_id"
    t.decimal "amount", precision: 16, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_partial_payments_on_customer_id"
    t.index ["transaction_id"], name: "index_partial_payments_on_transaction_id"
  end

  create_table "pre_registration_documents", force: :cascade do |t|
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pre_registrations", force: :cascade do |t|
    t.string "company_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proposals", force: :cascade do |t|
    t.integer "buyer_id"
    t.integer "supplier_id"
    t.integer "trading_parcel_id"
    t.decimal "price"
    t.integer "credit"
    t.text "notes"
    t.integer "status", default: 0
    t.integer "action_for"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "broker_id"
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text "message"
    t.string "username"
    t.integer "item"
    t.string "table"
    t.integer "month", limit: 2
    t.bigint "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "tender_id"
    t.integer "customer_id"
    t.string "key"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "flag_type", default: "Imp"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "round_loosers", force: :cascade do |t|
    t.integer "stone_id"
    t.integer "customer_id"
    t.integer "bid_id"
    t.integer "auction_round_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "auction_id"
  end

  create_table "round_winners", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "auction_round_id"
    t.integer "bid_id"
    t.integer "stone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "auction_id"
  end

  create_table "shareds", force: :cascade do |t|
    t.bigint "shared_to_id"
    t.bigint "shared_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shared_by_id"], name: "index_shareds_on_shared_by_id"
    t.index ["shared_to_id"], name: "index_shareds_on_shared_to_id"
  end

  create_table "sights", force: :cascade do |t|
    t.string "stone_type"
    t.string "source"
    t.string "box"
    t.integer "carats"
    t.integer "cost"
    t.integer "box_value_from"
    t.integer "box_value_to"
    t.string "sight"
    t.integer "price"
    t.integer "credit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tender_id"
    t.string "sight_reserved_price"
    t.float "yes_no_system_price"
    t.float "stone_winning_price"
    t.boolean "interest", default: true
    t.integer "status", default: 0
    t.float "starting_price"
  end

  create_table "stone_ratings", force: :cascade do |t|
    t.integer "stone_id"
    t.integer "customer_id"
    t.string "comments"
    t.string "valuation"
    t.integer "parcel_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stones", force: :cascade do |t|
    t.string "stone_type"
    t.integer "no_of_stones"
    t.float "size"
    t.float "weight"
    t.decimal "carat", precision: 10, scale: 5
    t.float "purity"
    t.string "color"
    t.boolean "polished"
    t.bigint "tender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deec_no"
    t.integer "lot_no"
    t.text "description"
    t.float "system_price"
    t.boolean "lot_permission"
    t.string "comments"
    t.string "valuation"
    t.integer "parcel_rating"
    t.integer "reserved_price"
    t.float "yes_no_system_price"
    t.float "stone_winning_price"
    t.integer "status", default: 0
    t.float "starting_price"
    t.index ["tender_id"], name: "index_stones_on_tender_id"
  end

  create_table "sub_company_credit_limits", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "credit_limit"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supplier_mines", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_supplier_mines_on_company_id"
  end

  create_table "supplier_notifications", force: :cascade do |t|
    t.integer "supplier_id"
    t.bigint "customer_id"
    t.boolean "notify"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_supplier_notifications_on_customer_id"
  end

  create_table "temp_stones", force: :cascade do |t|
    t.integer "tender_id"
    t.integer "lot_no"
    t.string "description"
    t.integer "no_of_stones"
    t.float "carat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tender_notifications", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "tender_id"
    t.boolean "notify"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tender_winners", force: :cascade do |t|
    t.integer "tender_id"
    t.integer "lot_no"
    t.string "selling_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.float "avg_selling_price"
  end

  create_table "tenders", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "open_date"
    t.datetime "close_date"
    t.boolean "tender_open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.boolean "send_confirmation"
    t.string "winner_list_file_name"
    t.string "winner_list_content_type"
    t.integer "winner_list_file_size"
    t.datetime "winner_list_updated_at"
    t.string "temp_document_file_name"
    t.string "temp_document_content_type"
    t.integer "temp_document_file_size"
    t.datetime "temp_document_updated_at"
    t.integer "company_id"
    t.string "deec_no_field"
    t.string "lot_no_field"
    t.string "desc_field"
    t.string "no_of_stones_field"
    t.string "weight_field"
    t.integer "sheet_no"
    t.string "winner_lot_no_field"
    t.string "winner_desc_field"
    t.string "winner_no_of_stones_field"
    t.string "winner_weight_field"
    t.string "winner_selling_price_field"
    t.string "winner_carat_selling_price_field"
    t.integer "winner_sheet_no"
    t.integer "reference_id"
    t.string "country"
    t.string "city"
    t.string "tender_type", default: "", null: false
    t.datetime "bidding_start"
    t.datetime "bidding_end"
    t.string "timezone"
    t.integer "supplier_mine_id"
    t.string "diamond_type"
    t.string "sight_document_file_name"
    t.string "sight_document_content_type"
    t.integer "sight_document_file_size"
    t.datetime "sight_document_updated_at"
    t.string "s_no_field"
    t.string "source_no_field"
    t.string "box_no_field"
    t.string "carats_no_field"
    t.string "cost_no_field"
    t.string "boxvalue_no_field"
    t.string "sight_no_field"
    t.string "price_no_field"
    t.string "credit_no_field"
    t.string "reserved_field"
    t.datetime "bid_open"
    t.datetime "bid_close"
    t.integer "round_duration"
    t.string "sight_reserved_field"
    t.integer "rounds_between_duration"
    t.datetime "round_open_time"
    t.integer "round", default: 1
    t.boolean "updated_after_round"
    t.string "sight_starting_price_field"
    t.string "stone_starting_price_field"
  end

  create_table "trading_documents", force: :cascade do |t|
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.string "credit_field"
    t.string "lot_no_field"
    t.string "desc_field"
    t.string "no_of_stones_field"
    t.string "weight_field"
    t.integer "sheet_no"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.string "diamond_type"
    t.string "source_field"
    t.string "box_field"
    t.string "cost_field"
    t.string "box_value_field"
    t.string "sight_field"
    t.string "price_field"
    t.index ["customer_id"], name: "index_trading_documents_on_customer_id"
  end

  create_table "trading_parcels", force: :cascade do |t|
    t.integer "lot_no"
    t.string "description"
    t.integer "no_of_stones"
    t.decimal "weight", precision: 16, scale: 2
    t.integer "credit_period"
    t.decimal "price"
    t.integer "company_id"
    t.bigint "customer_id"
    t.bigint "trading_document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cost"
    t.string "box_value"
    t.string "sight"
    t.string "source"
    t.string "box"
    t.boolean "sold", default: false
    t.string "uid"
    t.string "diamond_type"
    t.text "broker_ids"
    t.boolean "sale_all", default: false
    t.boolean "sale_none", default: true
    t.boolean "sale_broker", default: false
    t.boolean "sale_credit", default: false
    t.boolean "sale_demanded", default: false
    t.decimal "percent", precision: 16, scale: 2
    t.text "comment"
    t.index ["customer_id"], name: "index_trading_parcels_on_customer_id"
    t.index ["trading_document_id"], name: "index_trading_parcels_on_trading_document_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "buyer_id"
    t.integer "supplier_id"
    t.integer "trading_parcel_id"
    t.datetime "due_date"
    t.decimal "price"
    t.integer "credit"
    t.boolean "paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "buyer_confirmed", default: false
    t.text "reject_reason"
    t.datetime "reject_date"
    t.string "transaction_type"
    t.decimal "remaining_amount", precision: 16, scale: 2
    t.string "transaction_uid"
    t.string "diamond_type"
    t.decimal "total_amount", precision: 16, scale: 2
    t.string "invoice_no"
    t.boolean "ready_for_buyer"
    t.string "description"
  end

  create_table "versions", force: :cascade do |t|
    t.string "versioned_type"
    t.bigint "versioned_id"
    t.string "user_type"
    t.bigint "user_id"
    t.string "user_name"
    t.text "modifications"
    t.integer "number"
    t.integer "reverted_from"
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "object_changes"
    t.index ["created_at"], name: "index_versions_on_created_at"
    t.index ["number"], name: "index_versions_on_number"
    t.index ["tag"], name: "index_versions_on_tag"
    t.index ["user_id", "user_type"], name: "index_versions_on_user_id_and_user_type"
    t.index ["user_name"], name: "index_versions_on_user_name"
    t.index ["user_type", "user_id"], name: "index_versions_on_user_type_and_user_id"
    t.index ["versioned_id", "versioned_type"], name: "index_versions_on_versioned_id_and_versioned_type"
    t.index ["versioned_type", "versioned_id"], name: "index_versions_on_versioned_type_and_versioned_id"
  end

  create_table "winners", force: :cascade do |t|
    t.bigint "tender_id"
    t.bigint "customer_id"
    t.bigint "bid_id"
    t.bigint "stone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sight_id"
    t.index ["bid_id"], name: "index_winners_on_bid_id"
    t.index ["customer_id"], name: "index_winners_on_customer_id"
    t.index ["stone_id"], name: "index_winners_on_stone_id"
    t.index ["tender_id"], name: "index_winners_on_tender_id"
  end

  create_table "yes_no_buyer_interests", force: :cascade do |t|
    t.bigint "tender_id"
    t.bigint "stone_id"
    t.bigint "sight_id"
    t.bigint "customer_id"
    t.datetime "bid_open_time"
    t.datetime "bid_close_time"
    t.integer "round"
    t.string "reserved_price"
    t.boolean "interest", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "buyer_left", default: true
    t.integer "place_bid", default: 1
    t.index ["customer_id"], name: "index_yes_no_buyer_interests_on_customer_id"
    t.index ["sight_id"], name: "index_yes_no_buyer_interests_on_sight_id"
    t.index ["stone_id"], name: "index_yes_no_buyer_interests_on_stone_id"
    t.index ["tender_id"], name: "index_yes_no_buyer_interests_on_tender_id"
  end

  create_table "yes_no_buyer_winners", force: :cascade do |t|
    t.bigint "tender_id"
    t.bigint "stone_id"
    t.bigint "sight_id"
    t.bigint "customer_id"
    t.bigint "yes_no_buyer_interest_id"
    t.datetime "bid_open_time"
    t.datetime "bid_close_time"
    t.integer "round"
    t.string "winning_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_yes_no_buyer_winners_on_customer_id"
    t.index ["sight_id"], name: "index_yes_no_buyer_winners_on_sight_id"
    t.index ["stone_id"], name: "index_yes_no_buyer_winners_on_stone_id"
    t.index ["tender_id"], name: "index_yes_no_buyer_winners_on_tender_id"
    t.index ["yes_no_buyer_interest_id"], name: "index_yes_no_buyer_winners_on_yes_no_buyer_interest_id"
  end

end
