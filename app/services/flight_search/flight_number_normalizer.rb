# frozen_string_literal: true

module FlightSearch
  class FlightNumberNormalizer
    FLIGHT_NUMBER_REGEX = /\A([A-Z0-9]{2,3})(\d{1,4})\z/

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
        iata, number = extract_parts(flight_number: flight_number)
        iata + number.rjust(4, '0')
      end

      def extract_parts(flight_number:)
        [2, 3].each do |iata_length|
          iata = flight_number[0, iata_length]
          number = flight_number[iata_length..]

          return [iata, number] if iata&.match?(/\A[A-Z0-9]{2,3}\z/) && number&.match?(/\A\d{1,4}\z/)
        end
      end
    end
  end
end
