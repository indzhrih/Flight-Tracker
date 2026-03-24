# frozen_string_literal: true

module FlightSearch
  module Adapters
    class AdsbdbResponseAdapter
      class << self
        def call(response:)
          return response[:response] unless response[:response].is_a?(Hash)
          return response[:response] unless response[:status] == 200

          build_success_json(body: response)
        end

        private

        def build_success_json(body:)
          route = build_route(flight_route: body.dig(:response, 'flightroute'))

          {
            route: route,
            status: 'OK',
            distance: count_distance(route: route),
            error_message: nil
          }
        end

        def build_route(flight_route:)
          legs = build_route_legs(origin: build_airport(flight_route['origin']),
                                  destination: build_airport(flight_route['destination']),
                                  midpoint: build_airport(flight_route['midpoint']))

          legs.size == 1 ? legs.first : legs
        end

        def build_route_legs(origin:, destination:, midpoint:)
          if midpoint.present?
            [
              build_leg(departure: origin, arrival: midpoint, multi_leg: true),
              build_leg(departure: midpoint, arrival: destination, multi_leg: true)
            ]
          else
            [build_leg(departure: origin, arrival: destination)]
          end
        end

        def build_leg(departure:, arrival:, multi_leg: false)
          leg_hash = { departure: departure, arrival: arrival }
          leg_hash[:distance] = FlightSearch::DistanceCalculator.call(from: departure, to: arrival) if multi_leg

          leg_hash
        end

        def build_airport(airport)
          {
            iata: airport['iata_code'],
            city: airport['municipality'],
            country: airport['country_name'],
            latitude: airport['latitude'],
            longitude: airport['longitude']
          }
        end

        def count_distance(route:)
          return route[:distance] if route.is_a?(Hash)

          route.sum { |leg| leg[:distance] }
        end
      end
    end
  end
end
