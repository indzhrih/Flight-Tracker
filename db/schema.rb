# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_03_22_171006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", primary_key: "iata", id: { type: :string, limit: 3 }, force: :cascade do |t|
    t.string "city", null: false
    t.string "country", null: false
    t.decimal "latitude", precision: 5, scale: 2, null: false
    t.decimal "longitude", precision: 5, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", force: :cascade do |t|
    t.string "flight_number", limit: 7, null: false
    t.string "status", null: false
    t.integer "distance"
    t.string "error_message"
    t.datetime "fetched_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_number"], name: "index_flights_on_flight_number", unique: true
  end

  create_table "legs", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "distance"
    t.bigint "flight_id", null: false
    t.string "departure_airport_id", null: false
    t.string "arrival_airport_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrival_airport_id"], name: "index_legs_on_arrival_airport_id"
    t.index ["departure_airport_id"], name: "index_legs_on_departure_airport_id"
    t.index ["flight_id", "number"], name: "index_legs_on_flight_id_and_number", unique: true
    t.index ["flight_id"], name: "index_legs_on_flight_id"
  end

  add_foreign_key "legs", "airports", column: "arrival_airport_id", primary_key: "iata"
  add_foreign_key "legs", "airports", column: "departure_airport_id", primary_key: "iata"
  add_foreign_key "legs", "flights"
end
