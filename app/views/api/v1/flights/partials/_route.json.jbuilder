# frozen_string_literal: true

if route.is_a?(Array)
  json.array! route do |leg|
    json.partial! 'api/v1/flights/partials/leg', leg: leg
  end
else
  json.partial! 'api/v1/flights/partials/leg', leg: route
end
