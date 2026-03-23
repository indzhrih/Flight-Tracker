# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flight, type: :model do
  subject(:flight) { build(:flight) }

  context 'when using a valid factory' do
    it { is_expected.to be_valid }
  end

  describe 'default values' do
    subject(:flight) { create(:flight) }

    it 'sets flight_number not to nil by default' do
      expect(flight.flight_number).not_to be_nil
    end

    it "sets status to 'OK' by default" do
      expect(flight.status).to eq('OK')
    end

    it 'sets distance not to nil by default' do
      expect(flight.distance).not_to be_nil
    end

    it 'sets error_message to nil by default' do
      expect(flight.error_message).to be_nil
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:flight_number) }
    it { is_expected.to validate_presence_of(:status) }

    it { is_expected.to validate_uniqueness_of(:flight_number) }

    it { is_expected.to validate_length_of(:flight_number).is_at_least(6).is_at_most(7) }

    it { is_expected.to validate_numericality_of(:distance).is_greater_than(0) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:legs).dependent(:destroy) }
  end
end
