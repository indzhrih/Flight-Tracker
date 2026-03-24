# frozen_string_literal: true

module FlightSearch
  module Commands
    class SaveFlightToDatabase < BaseCommand
      class << self
        def execute(flight_number:, flight_data:)
          Flight.transaction do
            flight = create_flight(flight_number: flight_number, flight_data: flight_data)
            create_legs(flight: flight, route_data: flight_data[:route])
          end
        end

        private

        def create_flight(flight_number:, flight_data:)
          Flight.create!(
            flight_number: flight_number,
            status: 'OK',
            distance: flight_data[:distance],
            error_message: nil,
            fetched_at: Time.current
          )
        end

        def create_legs(flight:, route_data:)
          legs = route_data.is_a?(Array) ? route_data : [route_data]

          legs.each do |leg_data|
            flight.legs.create!(
              departure_airport: find_or_create_airport(airport_data: leg_data[:departure]),
              arrival_airport: find_or_create_airport(airport_data: leg_data[:arrival]),
              distance: leg_data[:distance] || flight.distance
            )
          end
        end

        def find_or_create_airport(airport_data:)
          Airport.find_or_create_by!(iata: airport_data[:iata]) do |airport|
            airport.city = airport_data[:city]
            airport.country = airport_data[:country]
            airport.latitude = airport_data[:latitude]
            airport.longitude = airport_data[:longitude]
          end
        end
      end
    end
  end
end
