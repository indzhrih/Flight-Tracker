# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport, type: :model do
  subject(:airport) { build(:airport) }

  context 'when using a valid factory' do
    it { is_expected.to be_valid }
  end

  describe 'default values' do
    it 'sets iata not to nil by default' do
      expect(airport.iata).not_to be_nil
    end

    it 'sets city not to nil by default' do
      expect(airport.city).not_to be_nil
    end

    it 'sets country not to nil by default' do
      expect(airport.country).not_to be_nil
    end

    it 'sets latitude not to nil by default' do
      expect(airport.latitude).not_to be_nil
    end

    it 'sets longitude not to nil by default' do
      expect(airport.longitude).not_to be_nil
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:iata) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }

    it { is_expected.to validate_length_of(:iata).is_equal_to(3) }

    it { is_expected.to validate_numericality_of(:longitude).is_in(-180..180) }
    it { is_expected.to validate_numericality_of(:latitude).is_in(-90..90) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:departure_legs) }
    it { is_expected.to have_many(:arrival_legs) }
  end
end
