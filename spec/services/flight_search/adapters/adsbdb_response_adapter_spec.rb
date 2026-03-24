# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  module Adapters
    RSpec.describe AdsbdbResponseAdapter do
      subject(:adapter) { described_class }

      describe '#call' do
        context 'when adsbdb API returns a successful response' do
          subject(:result) do
            adapter.call(response: Clients::AdsbdbClient.find_flight(flight_number: 'LH1234'))
          end

          it 'returns status OK' do
            expect(result[:status]).to eq('OK')
          end

          it 'returns error_message nil' do
            expect(result[:error_message]).to be_nil
          end

          it 'returns a route hash' do
            expect(result[:route]).to be_a(Hash)
          end

          it 'has departure and arrival keys' do
            expect(result[:route].keys).to contain_exactly(:departure, :arrival)
          end

          it 'has departure iata' do
            expect(result[:route][:departure][:iata]).to be_present
          end

          it 'has departure city' do
            expect(result[:route][:departure][:city]).to be_present
          end

          it 'has departure country' do
            expect(result[:route][:departure][:country]).to be_present
          end

          it 'has departure latitude' do
            expect(result[:route][:departure][:latitude]).to be_a(Float)
          end

          it 'has departure longitude' do
            expect(result[:route][:departure][:longitude]).to be_a(Float)
          end

          it 'has arrival iata' do
            expect(result[:route][:arrival][:iata]).to be_present
          end

          it 'has arrival city' do
            expect(result[:route][:arrival][:city]).to be_present
          end

          it 'has arrival country' do
            expect(result[:route][:arrival][:country]).to be_present
          end

          it 'has arrival latitude' do
            expect(result[:route][:arrival][:latitude]).to be_a(Float)
          end

          it 'has arrival longitude' do
            expect(result[:route][:arrival][:longitude]).to be_a(Float)
          end
        end

        context 'when API returns an error (404)' do
          subject(:result) do
            adapter.call(response: Clients::AdsbdbClient.find_flight(flight_number: 'INCORRECT'))
          end

          it 'returns a fail message' do
            expect(result).to eq('invalid callsign: INCORRECT')
          end

          it 'returns a non-empty string' do
            expect(result).to be_present
          end
        end
      end
    end
  end
end
