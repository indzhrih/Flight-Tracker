# frozen_string_literal: true

class FlightsController < ApplicationController
  def show
    render json: FlightSearch::FlightFinder.find_by_flight_number(flight_number: params[:flight_number])
  end
end
