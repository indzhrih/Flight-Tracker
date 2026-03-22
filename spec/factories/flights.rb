# frozen_string_literal: true

FactoryBot.define do
  factory :flight do
    flight_number { 'MyString' }
    distance { 1 }
    error_message { 'MyString' }
  end
end
