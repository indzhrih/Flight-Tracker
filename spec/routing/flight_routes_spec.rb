# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe 'Flight Routes', type: :routing do
      it 'routes show path' do
        expect(get: 'api/v1/flight/SU1234').to route_to(controller: 'api/v1/flights', action: 'show',
                                                        flight_number: 'SU1234')
      end
    end
  end
end
