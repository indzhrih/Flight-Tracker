# frozen_string_literal: true

class Flight < ApplicationRecord
  has_many :legs, dependent: :destroy

  enum :status, { ok: 'OK', fail: 'FAIL' }

  validates :flight_number, uniqueness: true, length: { in: 6..7 }
  validates :flight_number, :status, presence: true
  validates :distance, numericality: { greater_than: 0 }, allow_nil: true
end
