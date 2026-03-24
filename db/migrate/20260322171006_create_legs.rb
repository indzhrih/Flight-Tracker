# frozen_string_literal: true

class CreateLegs < ActiveRecord::Migration[7.2]
  def change
    create_table :legs do |t|
      t.integer :distance
      t.references :flight, null: false, foreign_key: true
      t.references :departure_airport, null: false, type: :string,
                                       foreign_key: { to_table: :airports, primary_key: :iata }
      t.references :arrival_airport, null: false, type: :string,
                                     foreign_key: { to_table: :airports, primary_key: :iata }

      t.timestamps
    end
  end
end
