# frozen_string_literal: true

module Api
  module V1
    class FlightsController < ApplicationController
      def show
        @flight_data = FlightSearch::FlightFinder.find_by_flight_number(flight_number: params[:flight_number])
        return render :show, formats: :json, status: :ok if @flight_data[:status] == 'OK'

        render :error, formats: :json, status: :not_found
      end
    end
  end
end
