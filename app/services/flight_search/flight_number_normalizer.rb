# frozen_string_literal: true

module FlightSearch
  class FlightNumberNormalizer
    FLIGHT_NUMBER_REGEX = /\A([A-Z]{2,3})(\d{1,4})\z/

    class << self
      def call(flight_number:)
        upcase_flight_number = flight_number.to_s.strip.upcase
        return nil unless valid_format?(flight_number: upcase_flight_number)

        normalize_valid_number(flight_number: upcase_flight_number)
      end

      private

      def valid_format?(flight_number:)
        flight_number.match?(FLIGHT_NUMBER_REGEX)
      end

      def normalize_valid_number(flight_number:)
        iata, number = flight_number.scan(FLIGHT_NUMBER_REGEX).first
        iata + number.rjust(4, '0')
      end
    end
  end
end
