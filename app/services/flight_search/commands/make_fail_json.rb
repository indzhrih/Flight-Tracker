# frozen_string_literal: true

module FlightSearch
  module Commands
    class MakeFailJson < BaseCommand
      def self.execute(error_message:)
        {
          route: nil,
          status: 'FAIL',
          distance: 0,
          error_message: error_message
        }
      end
    end
  end
end
