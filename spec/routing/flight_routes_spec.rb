# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flight Routes', type: :routing do
  it 'routes show path' do
    expect(get: '/flight/SU1234').to route_to(controller: 'flights', action: 'show', flight_number: 'SU1234')
  end
end
