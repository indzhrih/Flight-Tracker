# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  RSpec.describe FlightFinder do
    describe '#find_by_flight_number' do
      let(:correct_hash) do
        {
          route: {
            departure: { iata: 'FRA', city: 'Frankfurt am Main', country: 'Germany', latitude: 50.03, longitude: 8.57 },
            arrival: { iata: 'VIE', city: 'Vienna', country: 'Austria', latitude: 48.11, longitude: 16.57 }
          },
          status: 'OK',
          distance: '620',
          error_message: nil
        }
      end

      context 'when flight exists in database' do
        let(:airport_fra) do
          create(:airport, iata: 'FRA', city: 'Frankfurt am Main', country: 'Germany', latitude: 50.03, longitude: 8.57)
        end
        let(:airport_vie) do
          create(:airport, iata: 'VIE', city: 'Vienna', country: 'Austria', latitude: 48.11, longitude: 16.57)
        end
        let(:flight) { create(:flight, flight_number: 'LH1234', distance: 620) }
        let(:leg) { create(:leg, flight: flight, departure_airport: airport_fra, arrival_airport: airport_vie) }

        it 'returns correct hash from database' do
          expect(described_class.find_by_flight_number(flight_number: 'LH1234')).to eq(correct_hash)
        end
      end

      context 'when flight not in database but exists in ADSBdb API' do
        it 'returns correct hash from API' do
          expect(described_class.find_by_flight_number(flight_number: 'LH1234')).to eq(correct_hash)
        end
      end

      context 'when flight is not found in ADSBdb API' do
        let(:failure_hash) do
          {
            route: nil,
            status: 'FAIL',
            distance: 0,
            error_message: 'unknown callsign'
          }
        end

        it 'returns failure hash' do
          expect(described_class.find_by_flight_number(flight_number: 'AFL123')).to eq(failure_hash)
        end
      end
    end
  end
end
