# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  module Commands
    RSpec.describe MakeFailJson do
      subject(:service) { described_class }

      describe '#execute' do
        let(:failure_hash) do
          {
            route: nil,
            status: 'FAIL',
            distance: 0,
            error_message: 'Error message'
          }
        end

        it 'returns a fail hash with the given error message' do
          expect(service.execute(error_message: 'Error message')).to eq(failure_hash)
        end
      end
    end
  end
end
