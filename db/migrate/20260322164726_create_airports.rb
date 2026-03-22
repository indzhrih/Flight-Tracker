# frozen_string_literal: true

class CreateAirports < ActiveRecord::Migration[7.2]
  def change
    create_table :airports, id: false do |t|
      t.string :iata, limit: 3, primary_key: true
      t.string :city, null: false
      t.string :country, null: false
      t.decimal :latitude, precision: 5, scale: 2, null: false
      t.decimal :longitude, precision: 5, scale: 2, null: false

      t.timestamps
    end
  end
end
