# frozen_string_literal: true

module FlightSearch
  module Commands
    class MakeDatabaseJson < BaseCommand
      class << self
        def execute(flight_number:)
          flight = Flight.find_by(flight_number: flight_number)
          {
            route: build_route(legs: flight.legs),
            status: flight.status,
            distance: flight.distance.to_s,
            error_message: nil
          }
        end

        private

        def build_route(legs:)
          routes = legs.map do |leg|
            {
              departure: build_airport(airport: leg.departure_airport),
              arrival: build_airport(airport: leg.arrival_airport)
            }
          end

          legs.size == 1 ? routes.first : routes
        end

        def build_airport(airport:)
          {
            iata: airport.iata,
            city: airport.city,
            country: airport.country,
            latitude: airport.latitude,
            longitude: airport.longitude
          }
        end
      end
    end
  end
end
