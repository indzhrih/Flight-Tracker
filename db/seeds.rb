# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

airports = []
20.times do
  airports << Airport.find_or_create_by!(iata: Faker::Alphanumeric.alpha(number: 3).upcase) do |airport|
    airport.city = Faker::Address.city
    airport.country = Faker::Address.country
    airport.latitude = Faker::Address.latitude
    airport.longitude = Faker::Address.longitude
  end
end

50.times do
  flight_number = Faker::Alphanumeric.alpha(number: rand(2..3)).upcase + Faker::Number.number(digits: 4).to_s
  flight = Flight.find_or_create_by!(flight_number: flight_number) do |flight|
    flight.status = 'OK'
    flight.fetched_at = Faker::Time.between(from: 30.days.ago, to: Time.current)
    flight.error_message = nil
    flight.distance = nil
  end

  legs = []
  rand(1..3).times do |number|
    legs << Leg.find_or_create_by!(flight: flight, number: number + 1) do |leg|
      leg.departure_airport = airports.sample
      leg.arrival_airport = (airports - [leg.departure_airport]).sample
      leg.distance = Faker::Number.between(from: 1, to: 1000)
    end
  end

  flight.distance = legs.sum { |leg| leg.distance }
end
