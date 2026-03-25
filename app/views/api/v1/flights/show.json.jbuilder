# frozen_string_literal: true

json.route do
  json.partial! 'api/v1/flights/partials/route', route: @flight_data[:route]
end
json.status @flight_data[:status]
json.distance @flight_data[:distance]
json.error_message @flight_data[:error_message]
