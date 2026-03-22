# frozen_string_literal: true

class Airport < ApplicationRecord
  has_many :departure_legs, class_name: 'Leg', foreign_key: :departure_airport_id
  has_many :arrival_legs, class_name: 'Leg', foreign_key: :arrival_airport_id

  validates :iata, length: { is: 3 }
  validates :iata, :city, :country, :latitude, :longitude, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
