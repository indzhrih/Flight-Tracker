# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  module Commands
    RSpec.describe MakeAdsbdbJson do
      subject(:service) { described_class }

      describe '#execute' do
        context 'when flight exists in adsbdb API' do
          subject(:execute_command) { service.execute(flight_number: 'LH1234') }

          it 'returns a hash with status OK' do
            expect(execute_command[:status]).to eq('OK')
          end

          it 'creates a flight in the database' do
            expect { execute_command }.to change(Flight, :count).by(1)
          end
        end

        context 'when flight does not exist in adsbdb API' do
          subject(:execute_command) { service.execute(flight_number: 'INCORRECT') }

          it 'returns a fail message' do
            expect(execute_command).to eq('invalid callsign: INCORRECT')
          end

          it 'does not create a flight' do
            expect { execute_command }.not_to change(Flight, :count)
          end
        end
      end
    end
  end
end
