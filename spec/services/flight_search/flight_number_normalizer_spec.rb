# frozen_string_literal: true

require 'rails_helper'

module FlightSearch
  RSpec.describe FlightNumberNormalizer do
    subject(:service) { described_class.new }

    describe '#call' do
      context 'when flight_number is correct' do
        it 'normalizes "SU1234" to "SU1234"' do
          expect(described_class.call(flight_number: 'SU1234')).to eq('SU1234')
        end

        it 'normalizes "su1234" to "SU1234"' do
          expect(described_class.call(flight_number: 'su1234')).to eq('SU1234')
        end

        it 'normalizes "SU12" to "SU0012"' do
          expect(described_class.call(flight_number: 'SU12')).to eq('SU0012')
        end

        it 'normalizes " SU12 " to "SU0012"' do
          expect(described_class.call(flight_number: '  SU12  ')).to eq('SU0012')
        end

        it 'normalizes "AFL1234" to "AFL1234"' do
          expect(described_class.call(flight_number: 'AFL1234')).to eq('AFL1234')
        end

        it 'normalizes "AFL12" to "AFL0012"' do
          expect(described_class.call(flight_number: 'AFL12')).to eq('AFL0012')
        end

        it 'normalizes "SU012" to "SU0012"' do
          expect(described_class.call(flight_number: 'SU012')).to eq('SU0012')
        end

        it 'normalizes "SU0000" to "SU0000"' do
          expect(described_class.call(flight_number: 'SU0000')).to eq('SU0000')
        end
      end

      context 'when flight_number is incorrect' do
        it 'returns nil for empty string' do
          expect(described_class.call(flight_number: '')).to be_nil
        end

        it 'returns nil for nil' do
          expect(described_class.call(flight_number: nil)).to be_nil
        end

        it 'returns nil for "SU"' do
          expect(described_class.call(flight_number: 'SU')).to be_nil
        end

        it 'returns nil for "SU12345"' do
          expect(described_class.call(flight_number: 'SU12345')).to be_nil
        end

        it 'returns nil for "SU123A"' do
          expect(described_class.call(flight_number: 'SU123A')).to be_nil
        end

        it 'returns nil for "S1234"' do
          expect(described_class.call(flight_number: 'S1234')).to be_nil
        end

        it 'returns nil for "SU1234A"' do
          expect(described_class.call(flight_number: 'SU1234A')).to be_nil
        end

        it 'returns nil for "SU-1234"' do
          expect(described_class.call(flight_number: 'SU-1234')).to be_nil
        end

        it 'returns nil for "SU 1234"' do
          expect(described_class.call(flight_number: 'SU 1234')).to be_nil
        end
      end
    end
  end
end
