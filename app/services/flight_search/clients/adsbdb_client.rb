# frozen_string_literal: true

module FlightSearch
  module Clients
    class AdsbdbClient
      BASE_URL = 'https://api.adsbdb.com/v0'

      class << self
        def connection
          @connection ||= Faraday.new(url: BASE_URL) do |faraday|
            faraday.response :json
            faraday.adapter :net_http
          end
        end

        def find_flight(flight_number:)
          connection.get("callsign/#{flight_number}")
        rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
          { error_message: e.message }
        end
      end
    end
  end
end
