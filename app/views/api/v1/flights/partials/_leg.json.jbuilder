# frozen_string_literal: true

json.departure do
  json.partial! 'api/v1/flights/partials/airports', airport: leg[:departure]
end

json.arrival do
  json.partial! 'api/v1/flights/partials/airports', airport: leg[:arrival]
end

json.distance leg[:distance] if leg[:distance].present?
