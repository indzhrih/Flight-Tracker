# frozen_string_literal: true

module FlightSearch
  module Clients
    class AdsbdbClient
      BASE_URL = 'https://api.adsbdb.com'

      class << self
        def connection
          @connection ||= Faraday.new(url: BASE_URL) do |faraday|
            faraday.request :json
            faraday.response :json
            faraday.response :follow_redirects
            faraday.adapter :net_http
            faraday.response :logger, Rails.logger, bodies: true
          end
        end

        def find_flight(flight_number:)
          connection.get("/v0/callsign/#{flight_number}")
        rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
          { error_message: e.message }
        end
      end
    end
  end
end
