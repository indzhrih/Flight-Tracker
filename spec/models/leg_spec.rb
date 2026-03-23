# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Leg, type: :model do
  subject(:leg) { build(:leg) }

  context 'when using a valid factory' do
    it { is_expected.to be_valid }
  end

  describe 'default values' do
    subject(:leg) { create(:leg) }

    it 'sets distance not to nil by default' do
      expect(leg.distance).not_to be_nil
    end
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:distance).is_greater_than(0) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:flight) }
    it { is_expected.to belong_to(:departure_airport).class_name('Airport') }
    it { is_expected.to belong_to(:arrival_airport).class_name('Airport') }
  end
end
