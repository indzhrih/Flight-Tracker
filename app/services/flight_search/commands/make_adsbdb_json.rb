# frozen_string_literal: true

module FlightSearch
  module Commands
    class MakeAdsbdbJson < BaseCommand
      class << self
        def execute(flight_number:)
          response = Clients::AdsbdbClient.find_flight(flight_number: flight_number)
          result = Adapters::AdsbdbResponseAdapter.call(response: { status: response.status, response: response.body })
          SaveFlightToDatabase.execute(flight_number: flight_number, flight_data: result) if result.is_a?(Hash)

          result
        end
      end
    end
  end
end
