# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  RSpec.describe DistanceCalculator do
    subject(:service) { described_class }

    describe '#call' do
      it 'returns 0 when coordinates are the same' do
        expect(service.call(
                 from: { latitude: 10.0, longitude: 20.0 },
                 to: { latitude: 10.0, longitude: 20.0 }
               )).to eq(0)
      end

      it 'returns 0 when both points have zero coordinates' do
        expect(service.call(
                 from: { latitude: 0.0, longitude: 0.0 },
                 to: { latitude: 0.0, longitude: 0.0 }
               )).to eq(0)
      end

      it 'returns a positive distance for different coordinates' do
        expect(service.call(
                 from: { latitude: 50.0, longitude: 10.0 },
                 to: { latitude: -30.0, longitude: -50.0 }
               )).to be_a(Integer).and be > 0
      end

      it 'takes string arguments' do
        expect(service.call(
                 from: { latitude: '55.9726', longitude: '37.4146' },
                 to: { latitude: '59.8003', longitude: '30.2625' }
               )).to be_a(Integer)
      end

      it 'calculates distance between Moscow and Saint Petersburg' do
        expect(service.call(
                 from: { latitude: 55.9726, longitude: 37.4146 },
                 to: { latitude: 59.8003, longitude: 30.2625 }
               )).to be_within(5).of(599)
      end

      it 'calculates distance between New York and London' do
        expect(service.call(
                 from: { latitude: 40.6413, longitude: -73.7781 },
                 to: { latitude: 51.4700, longitude: -0.4543 }
               )).to be_within(5).of(5540)
      end
    end
  end
end
