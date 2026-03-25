# frozen_string_literal: true

require 'csv'

namespace :flights do
  desc 'Fill a CSV file with flight information'
  task :fill_csv, [:input_file] => :environment do |_task, args|
    CSV.open(File.join(File.dirname(args[:input_file]), 'flights_numbers_filled.csv'), 'wb') do |csv_out|
      csv_out << CSV.open(args[:input_file], 'r', &:readline)

      CSV.foreach(args[:input_file], headers: true) do |row|
        csv_out << fill_row(row: row)
      end
    end
  end
end

def fill_row(row:)
  result = FlightSearch::FlightFinder.find_by_flight_number(flight_number: row['Example flight number'])
  return build_success_result(row: row, result: result) if result[:status] == 'OK'

  build_failure_result(row: row)
end

def build_success_result(row:, result:)
  legs = result[:route].is_a?(Array) ? result[:route] : [result[:route]]

  [
    row['Example flight number'],
    FlightSearch::FlightNumberNormalizer.call(flight_number: row['Example flight number']),
    'OK',
    legs.size,
    legs.first[:departure][:iata],
    legs.last[:arrival][:iata],
    result[:distance]
  ]
end

def build_failure_result(row:)
  [row['Example flight number'], row['Example flight number'], 'FAIL', nil, nil, nil, nil]
end
