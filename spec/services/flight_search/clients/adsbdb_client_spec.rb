# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  module Clients
    RSpec.describe AdsbdbClient do
      subject(:service) { described_class }

      describe '#find_flight' do
        context 'when flight exists' do
          it 'returns response with status 200' do
            expect(service.find_flight(flight_number: 'LH1234').status).to eq(200)
          end
        end

        context 'when flight does not exist' do
          it 'returns response with status 404' do
            expect(service.find_flight(flight_number: 'INVALID').status).to eq(404)
          end
        end
      end
    end
  end
end
