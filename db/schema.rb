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

ActiveRecord::Schema.define(version: 20150105213228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bins", force: true do |t|
    t.integer  "exemplar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colours", force: true do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hex"
    t.json     "lab"
    t.json     "rgb"
    t.integer  "bin_id"
    t.json     "hsb"
  end

  create_table "photo_colours", force: true do |t|
    t.integer  "photo_id"
    t.integer  "closest_colour_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "outlier"
    t.float    "coverage"
    t.string   "outlier_channel"
    t.float    "z_score"
    t.string   "hex"
    t.json     "lab"
    t.json     "rgb"
    t.json     "hsb"
    t.string   "label"
  end

  create_table "photos", force: true do |t|
    t.integer  "px_id"
    t.string   "px_name"
    t.integer  "px_category"
    t.json     "px_user"
    t.boolean  "px_for_sale"
    t.boolean  "px_store_download"
    t.integer  "px_license_type"
    t.boolean  "px_privacy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "px_link"
    t.string   "px_image"
    t.float    "hue_mean"
    t.float    "hue_deviation"
    t.float    "saturation_mean"
    t.float    "saturation_deviation"
    t.float    "brightness_mean"
    t.float    "brightness_deviation"
    t.boolean  "from_500px"
  end

  add_index "photos", ["px_id"], name: "index_photos_on_px_id", using: :btree

end
