# frozen_string_literal: true

module FlightSearch
  class FlightFinder
    include Commands

    class << self
      def find_by_flight_number(flight_number:)
        flight_number = FlightNumberNormalizer.call(flight_number: flight_number)
        return error_response(message: 'Incorrect flight number') unless flight_number

        result = find_in_database(flight_number: flight_number)
        return result if result.present?

        fetch_from_adsbdb_api(flight_number: flight_number)
      end

      private

      def find_in_database(flight_number:)
        MakeDatabaseJson.execute(flight_number: flight_number)
      end

      def fetch_from_adsbdb_api(flight_number:)
        adsbdb_result = MakeAdsbdbJson.execute(flight_number: flight_number)
        return adsbdb_result if adsbdb_result.is_a?(Hash)

        error_response(message: adsbdb_result)
      end

      def error_response(message:)
        MakeFailJson.execute(error_message: message)
      end
    end
  end
end
