# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  module Commands
    RSpec.describe SaveFlightToDatabase do
      subject(:service) { described_class }

      let(:departure_attrs) { attributes_for(:airport, iata: 'FRA', city: 'Frankfurt am Main', country: 'Germany') }
      let(:midpoint_attrs) { attributes_for(:airport, iata: 'MUC', city: 'Munich', country: 'Germany') }
      let(:arrival_attrs) { attributes_for(:airport, iata: 'VIE', city: 'Vienna', country: 'Austria') }
      let(:route_data) do
        {
          departure: departure_attrs.slice(:iata, :city, :country, :latitude, :longitude),
          arrival: arrival_attrs.slice(:iata, :city, :country, :latitude, :longitude)
        }
      end

      describe '#execute' do
        context 'with single leg route' do
          subject(:execute_command) do
            service.execute(flight_number: 'LH1234', flight_data: { route: route_data, distance: '1234' })
          end

          it 'creates a flight' do
            expect { execute_command }.to change(Flight, :count).by(1)
          end

          it 'creates a leg' do
            expect { execute_command }.to change(Leg, :count).by(1)
          end

          it 'creates two airports' do
            expect { execute_command }.to change(Airport, :count).by(2)
          end
        end

        context 'with multi‑leg route' do
          subject(:execute_command) do
            service.execute(flight_number: 'LH1234', flight_data: { route: route_data, distance: '1234' })
          end

          let(:route_data) do
            [
              {
                departure: departure_attrs.slice(:iata, :city, :country, :latitude, :longitude),
                arrival: midpoint_attrs.slice(:iata, :city, :country, :latitude, :longitude),
                distance: '300'
              },
              {
                departure: midpoint_attrs.slice(:iata, :city, :country, :latitude, :longitude),
                arrival: arrival_attrs.slice(:iata, :city, :country, :latitude, :longitude),
                distance: '350'
              }
            ]
          end

          it 'creates a flight' do
            expect { execute_command }.to change(Flight, :count).by(1)
          end

          it 'creates two legs' do
            expect { execute_command }.to change(Leg, :count).by(2)
          end

          it 'creates three airports' do
            expect { execute_command }.to change(Airport, :count).by(3)
          end
        end

        context 'when airports already exist' do
          subject(:execute_command) do
            service.execute(flight_number: 'LH1234', flight_data: { route: route_data, distance: '1234' })
          end

          before do
            create(:airport, iata: 'FRA')
            create(:airport, iata: 'VIE')
          end

          it 'creates a flight' do
            expect { execute_command }.to change(Flight, :count).by(1)
          end

          it 'creates a leg' do
            expect { execute_command }.to change(Leg, :count).by(1)
          end

          it 'does not create new airports' do
            expect { execute_command }.not_to change(Airport, :count)
          end
        end
      end
    end
  end
end
