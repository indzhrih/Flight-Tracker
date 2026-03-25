# frozen_string_literal: true

json.route nil
json.status @flight_data[:status]
json.distance @flight_data[:distance]
json.error_message @flight_data[:error_message]
