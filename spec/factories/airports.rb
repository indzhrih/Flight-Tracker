# frozen_string_literal: true

FactoryBot.define do
  factory :airport do
    iata { 'MyString' }
    city { 'MyString' }
    country { 'MyString' }
    latitude { '9.99' }
    longitude { '9.99' }
  end
end
