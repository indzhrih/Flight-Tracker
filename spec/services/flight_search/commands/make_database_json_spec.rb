# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  module Commands
    RSpec.describe MakeDatabaseJson do
      subject(:service) { described_class }

      describe '.execute' do
        context 'when flight does not exist' do
          it 'returns nil' do
            expect(service.execute(flight_number: 'NON_EXIST')).to be_nil
          end
        end

        context 'when flight exists' do
          before { create(:flight, flight_number: 'LH1234') }

          it 'returns status OK' do
            expect(service.execute(flight_number: 'LH1234')[:status]).to eq('OK')
          end

          it 'returns nil error_message' do
            expect(service.execute(flight_number: 'LH1234')[:error_message]).to be_nil
          end
        end

        context 'with multiple legs' do
          before { create(:flight, :with_multi_leg, flight_number: 'LH1234') }

          it 'returns route as an array' do
            expect(service.execute(flight_number: 'LH1234')[:route]).to be_an(Array)
          end

          it 'returns status OK' do
            expect(service.execute(flight_number: 'LH1234')[:status]).to eq('OK')
          end

          it 'returns nil error_message' do
            expect(service.execute(flight_number: 'LH1234')[:error_message]).to be_nil
          end
        end
      end
    end
  end
end
