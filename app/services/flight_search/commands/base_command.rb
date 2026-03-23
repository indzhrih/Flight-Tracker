# frozen_string_literal: true

module FlightSearch
  module Commands
    class BaseCommand
      def execute
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end
