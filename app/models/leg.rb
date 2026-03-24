# frozen_string_literal: true

class Leg < ApplicationRecord
  belongs_to :flight
  belongs_to :departure_airport, class_name: 'Airport'
  belongs_to :arrival_airport, class_name: 'Airport'

  validates :distance, numericality: { greater_than: 0 }, allow_nil: true
end
