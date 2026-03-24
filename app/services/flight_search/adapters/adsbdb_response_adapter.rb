# frozen_string_literal: true

module FlightSearch
  module Adapters
    class AdsbdbResponseAdapter
      class << self
        def call(response:)
          return response.body['response'] unless response.status == 200
          return response.body['response'] if response.body['response'].nil?
          return response.body['response'] unless response.body['response'].is_a?(Hash)

          build_success_json(body: response.body)
        end

        private

        def build_success_json(body:)
          route = build_route(flight_route: body.dig('response', 'flightroute'))

          {
            route: route,
            status: 'OK',
            distance: count_distance(route: route).to_s,
            error_message: nil
          }
        end

        def build_route(flight_route:)
          legs = build_route_legs(origin: build_airport(airport: flight_route['origin']),
                                  destination: build_airport(airport: flight_route['destination']),
                                  midpoint: build_airport(airport: flight_route['midpoint']))

          legs.size == 1 ? legs.first : legs
        end

        def build_route_legs(origin:, destination:, midpoint: nil)
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

        def build_airport(airport:)
          return nil if airport.blank?

          {
            iata: airport['iata_code'],
            city: airport['municipality'],
            country: airport['country_name'],
            latitude: airport['latitude'].to_f.round(2),
            longitude: airport['longitude'].to_f.round(2)
          }
        end

        def count_distance(route:)
          return route.sum { |leg| leg[:distance] } unless route.is_a?(Hash)

          DistanceCalculator.call(from: route[:departure], to: route[:arrival])
        end
      end
    end
  end
end
