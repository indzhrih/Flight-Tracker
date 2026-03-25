# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/flights/show.json.jbuilder', type: :view do
  subject(:json) { JSON.parse(rendered) }

  let(:departure_airport) do
    { iata: 'FRA', city: 'Frankfurt am Main', country: 'Germany', latitude: 50.03, longitude: 8.57 }
  end
  let(:arrival_airport) { { iata: 'VIE', city: 'Vienna', country: 'Austria', latitude: 48.11, longitude: 16.57 } }

  context 'with single-leg route' do
    let(:flight_data) do
      {
        route: {
          departure: departure_airport,
          arrival: arrival_airport
        },
        status: 'OK',
        distance: '620',
        error_message: nil
      }
    end

    before do
      assign(:flight_data, flight_data)
      render template: 'api/v1/flights/show', formats: [:json]
    end

    it 'renders route' do
      expect(json['route']).to be_present
    end

    it 'renders status' do
      expect(json['status']).to eq('OK')
    end

    it 'renders distance' do
      expect(json['distance']).to eq('620')
    end

    it 'renders error_message' do
      expect(json['error_message']).to be_nil
    end

    it 'renders departure iata' do
      expect(json.dig('route', 'departure', 'iata')).to eq(departure_airport[:iata])
    end

    it 'renders departure city' do
      expect(json.dig('route', 'departure', 'city')).to eq(departure_airport[:city])
    end

    it 'renders departure country' do
      expect(json.dig('route', 'departure', 'country')).to eq(departure_airport[:country])
    end

    it 'renders departure latitude' do
      expect(json.dig('route', 'departure', 'latitude')).to eq(departure_airport[:latitude])
    end

    it 'renders departure longitude' do
      expect(json.dig('route', 'departure', 'longitude')).to eq(departure_airport[:longitude])
    end

    it 'renders arrival iata' do
      expect(json.dig('route', 'arrival', 'iata')).to eq(arrival_airport[:iata])
    end

    it 'renders arrival city' do
      expect(json.dig('route', 'arrival', 'city')).to eq(arrival_airport[:city])
    end

    it 'renders arrival country' do
      expect(json.dig('route', 'arrival', 'country')).to eq(arrival_airport[:country])
    end

    it 'renders arrival latitude' do
      expect(json.dig('route', 'arrival', 'latitude')).to eq(arrival_airport[:latitude])
    end

    it 'renders arrival longitude' do
      expect(json.dig('route', 'arrival', 'longitude')).to eq(arrival_airport[:longitude])
    end
  end

  context 'with multi-leg route' do
    let(:midpoint_airport) { { iata: 'MUC', city: 'Munich', country: 'Germany', latitude: 48.35, longitude: 11.79 } }

    let(:flight_data) do
      {
        route: [
          {
            departure: departure_airport,
            arrival: midpoint_airport,
            distance: '300'
          },
          {
            departure: midpoint_airport,
            arrival: arrival_airport,
            distance: '350'
          }
        ],
        status: 'OK',
        distance: '650',
        error_message: nil
      }
    end

    before do
      assign(:flight_data, flight_data)
      render template: 'api/v1/flights/show', formats: [:json]
    end

    it 'renders route as array' do
      expect(json['route']).to be_an(Array)
    end

    it 'renders status' do
      expect(json['status']).to eq('OK')
    end

    it 'renders distance' do
      expect(json['distance']).to eq('650')
    end

    it 'renders error_message' do
      expect(json['error_message']).to be_nil
    end

    it 'renders first leg departure iata' do
      expect(json.dig('route', 0, 'departure', 'iata')).to eq(departure_airport[:iata])
    end

    it 'renders first leg arrival iata' do
      expect(json.dig('route', 0, 'arrival', 'iata')).to eq(midpoint_airport[:iata])
    end

    it 'renders first leg distance' do
      expect(json.dig('route', 0, 'distance')).to eq('300')
    end

    it 'renders second leg departure iata' do
      expect(json.dig('route', 1, 'departure', 'iata')).to eq(midpoint_airport[:iata])
    end

    it 'renders second leg arrival iata' do
      expect(json.dig('route', 1, 'arrival', 'iata')).to eq(arrival_airport[:iata])
    end

    it 'renders second leg distance' do
      expect(json.dig('route', 1, 'distance')).to eq('350')
    end
  end
end
