# frozen_string_literal: true

class CreateFlights < ActiveRecord::Migration[7.2]
  def change
    create_table :flights do |t|
      t.string :flight_number, limit: 7, null: false
      t.string :status, null: false
      t.integer :distance
      t.string :error_message
      t.timestamp :fetched_at

      t.timestamps
    end

    add_index :flights, :flight_number, unique: true
  end
end
