# frozen_string_literal: true

module FlightSearch
  class FlightFinder
    include Commands

    def self.find_by_flight_number(flight_number:)
      flight_number = FlightNumberNormalizer.call(flight_number: flight_number)
      return MakeFailJson.execute(error_message: 'Incorrect flight number') if flight_number.nil?

      database_json = MakeDatabaseJson.execute(flight_number: flight_number)
      database_json.presence
    end
  end
end
