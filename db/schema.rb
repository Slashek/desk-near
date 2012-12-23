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

ActiveRecord::Schema.define(:version => 20121222212201) do

  create_table "amenities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "amenities_listings", :force => true do |t|
    t.integer "amenity_id"
    t.integer "listing_id"
  end

  create_table "availabilities", :force => true do |t|
    t.integer  "listing_id"
    t.date     "date"
    t.integer  "quantity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "listings", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "address"
    t.float    "lat"
    t.float    "lon"
    t.integer  "quantity"
    t.string   "web_listing_url"
    t.string   "api_listing_url"
    t.string   "api_rating_url"
    t.string   "api_connections_url"
    t.string   "api_patrons_url"
    t.string   "api_availability_url"
    t.string   "api_reservation_url"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "listings_organizations", :force => true do |t|
    t.integer "organization_id"
    t.integer "listing_id"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "prices", :force => true do |t|
    t.float    "amount"
    t.string   "label"
    t.string   "currency_code"
    t.string   "period"
    t.integer  "listing_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "ratings", :force => true do |t|
    t.float    "average"
    t.integer  "count"
    t.integer  "listing_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
