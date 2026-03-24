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

if Rails.env.development?
  Flight.destroy_all
  Leg.destroy_all
  Airport.destroy_all

  airports = Array.new(20) do
    Airport.create!(
      iata: Faker::Alphanumeric.alpha(number: 3).upcase,
      city: Faker::Address.city,
      country: Faker::Address.country,
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude
    )
  end

  50.times do
    flight = Flight.create!(
      flight_number: Faker::Alphanumeric.alpha(number: rand(2..3)).upcase + Faker::Number.number(digits: 4).to_s,
      status: :ok,
      fetched_at: Faker::Time.between(from: 30.days.ago, to: Time.current),
      error_message: nil
    )

    rand(1..3).times do
      departure = airports.sample
      flight.legs.create!(
        departure_airport: departure,
        arrival_airport: (airports - [departure]).sample,
        distance: Faker::Number.between(from: 1, to: 1000)
      )
    end

    flight.update!(distance: flight.legs.sum(:distance))
  end
end
