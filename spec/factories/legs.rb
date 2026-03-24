# frozen_string_literal: true

FactoryBot.define do
  factory :leg do
    distance { Faker::Number.between(from: 1, to: 1000) }

    association :flight
    departure_airport { association :airport }
    arrival_airport { association :airport }
  end
end
