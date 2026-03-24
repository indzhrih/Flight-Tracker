# frozen_string_literal: true

module FlightSearch
  class DistanceCalculator
    EARTH_RADIUS = 6371
    RADIAN_PER_DEGREE = Math::PI / 180

    class << self
      def call(from:, to:)
        haversine_a = count_haversine_a(latitude1: from[:latitude].to_f, longitude1: from[:longitude].to_f,
                                        latitude2: to[:latitude].to_f, longitude2: to[:longitude].to_f)
        count_final_result(haversine_a: haversine_a)
      end

      private

      def count_haversine_a(latitude1:, longitude1:, latitude2:, longitude2:)
        latitude_difference = (latitude2 - latitude1) * RADIAN_PER_DEGREE
        longitude_difference = (longitude2 - longitude1) * RADIAN_PER_DEGREE
        latitude_radian1 = latitude1 * RADIAN_PER_DEGREE
        latitude_radian2 = latitude2 * RADIAN_PER_DEGREE

        count_sin(value: latitude_difference) + (Math.cos(latitude_radian1) * Math.cos(latitude_radian2) *
          count_sin(value: longitude_difference))
      end

      def count_final_result(haversine_a:)
        (EARTH_RADIUS * 2 * Math.atan2(Math.sqrt(haversine_a), Math.sqrt(1 - haversine_a))).round
      end

      def count_sin(value:)
        Math.sin(value / 2)**2
      end
    end
  end
end
