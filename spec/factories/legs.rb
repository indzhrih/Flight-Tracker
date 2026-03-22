# frozen_string_literal: true

FactoryBot.define do
  factory :leg do
    flight_id { 1 }
    number { 1 }
    departure_airport_id { 'MyString' }
    arrival_airport_id { 'MyString' }
    distance { 1 }
  end
end
