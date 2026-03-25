# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/flights/error.json.jbuilder', type: :view do
  subject(:json) { JSON.parse(rendered) }

  let(:flight_data) do
    { route: nil, status: 'FAIL', distance: 0, error_message: 'Incorrect flight number' }
  end

  before do
    assign(:flight_data, flight_data)
    render template: 'api/v1/flights/error', formats: [:json]
  end

  it 'renders route' do
    expect(json['route']).to be_nil
  end

  it 'renders status' do
    expect(json['status']).to eq('FAIL')
  end

  it 'renders distance' do
    expect(json['distance']).to eq(0)
  end

  it 'renders error_message' do
    expect(json['error_message']).to eq('Incorrect flight number')
  end
end
