# frozen_string_literal: true

require 'rails_helper'
require 'csv'
require 'rake'

RSpec.describe 'flights:fill_csv', type: :task do
  let(:correct_header) do
    [
      'Example flight number',
      'Flight number used for lookup',
      'Lookup status',
      'Number of legs',
      'First leg departure airport IATA',
      'Last leg arrival airport IATA',
      'Distance in kilometers'
    ]
  end

  describe 'filling source CSV file' do
    let(:tmp_dir) { Dir.mktmpdir }
    let(:output_file) { File.join(tmp_dir, 'flights_numbers_filled.csv') }

    before do
      Rails.application.load_tasks unless Rake::Task.task_defined?('flights:fill_csv')
      Rake::Task['flights:fill_csv'].reenable
    end

    after do
      FileUtils.rm_rf(tmp_dir)
    end

    context 'when source csv contains one correct flight number' do
      let(:flight) do
        create(:flight, :with_single_leg, flight_number: 'SU0012', status: 'OK', distance: 1234)
      end
      let(:input_rows) { [correct_header, ['SU12']] }

      before do
        flight
        CSV.open(File.join(tmp_dir, 'flights.csv'), 'wb') do |csv|
          input_rows.each { |row| csv << row }
        end
        Rake::Task['flights:fill_csv'].invoke(File.join(tmp_dir, 'flights.csv'))
      end

      it 'fills correct flight number row properly' do
        expect(CSV.read(output_file)).to eq([correct_header, %w[SU12 SU0012 OK 1 FRA VIE 1234]])
      end
    end

    context 'when source csv contains invalid flight numbers' do
      let(:input_rows) { [correct_header, ['BAD'], ['WRONG']] }
      let(:expected_rows) do
        [
          correct_header,
          ['BAD', 'BAD', 'FAIL', nil, nil, nil, nil],
          ['WRONG', 'WRONG', 'FAIL', nil, nil, nil, nil]
        ]
      end

      before do
        CSV.open(File.join(tmp_dir, 'flights.csv'), 'wb') do |csv|
          input_rows.each { |row| csv << row }
        end
        Rake::Task['flights:fill_csv'].invoke(File.join(tmp_dir, 'flights.csv'))
      end

      it 'creates output file next to source file' do
        expect(File.exist?(output_file)).to be(true)
      end

      it 'parses source csv and writes expected rows' do
        expect(CSV.read(output_file)).to eq(expected_rows)
      end
    end

    context 'when source csv contains only a header' do
      let(:input_rows) { [correct_header] }
      let(:expected_rows) { [correct_header] }

      before do
        CSV.open(File.join(tmp_dir, 'flights.csv'), 'wb') do |csv|
          input_rows.each { |row| csv << row }
        end
        Rake::Task['flights:fill_csv'].invoke(File.join(tmp_dir, 'flights.csv'))
      end

      it 'writes header only' do
        expect(CSV.read(output_file)).to eq(expected_rows)
      end
    end
  end
end
