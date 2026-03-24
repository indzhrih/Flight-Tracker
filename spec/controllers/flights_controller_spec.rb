# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightsController, type: :controller do
  describe 'GET show' do
    context 'when flight_number is correct' do
      before { get :show, params: { flight_number: 'SU1234' } }

      it 'returns 200 status' do
        expect(response).to have_http_status(200)
      end

      it 'renders correct json' do
        expect(response.parsed_body['status']).to eq('OK')
      end
    end

    context 'when flight_number is incorrect' do
      before { get :show, params: { flight_number: 'INVALID' } }

      it 'returns 200 status' do
        expect(response).to have_http_status(200)
      end

      it 'renders fail json' do
        expect(response.parsed_body['status']).to eq('FAIL')
      end
    end
  end
end
