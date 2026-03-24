# frozen_string_literal: true

module FlightSearch
  module Commands
    class MakeDatabaseJson < BaseCommand
      class << self
        def execute(flight_number:)
          flight = Flight.includes(legs: %i[departure_airport arrival_airport]).find_by(flight_number: flight_number)
          return nil if flight.nil?

          {
            route: build_route(legs: flight.legs),
            status: flight.status,
            distance: flight.distance.to_s,
            error_message: nil
          }
        end

        private

        def build_route(legs:)
          route_data = legs.map do |leg|
            segment = {
              departure: build_airport(airport: leg.departure_airport),
              arrival: build_airport(airport: leg.arrival_airport)
            }
            segment[:distance] = leg.distance.to_s if legs.size > 1
            segment
          end

          legs.size == 1 ? route_data.first : route_data
        end

        def build_airport(airport:)
          {
            iata: airport.iata,
            city: airport.city,
            country: airport.country,
            latitude: airport.latitude.to_f,
            longitude: airport.longitude.to_f
          }
        end
      end
    end
  end
end
