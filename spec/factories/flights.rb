# frozen_string_literal: true

FactoryBot.define do
  factory :flight do
    flight_number { Faker::Alphanumeric.alpha(number: rand(2..3)).upcase + Faker::Number.number(digits: 4).to_s }
    status { 'OK' }
    distance { Faker::Number.between(from: 1, to: 15_000) }
    error_message { nil }
  end

  trait :fail do
    status { 'FAIL' }
    error_message { Faker::Lorem.sentence }
  end

  trait :with_multi_leg do
    after(:create) do |flight|
      fra = create(:airport, iata: 'FRA')
      muc = create(:airport, iata: 'MUC')
      vie = create(:airport, iata: 'VIE')
      create(:leg, flight: flight, departure_airport: fra, arrival_airport: muc)
      create(:leg, flight: flight, departure_airport: muc, arrival_airport: vie)
    end
  end
end
