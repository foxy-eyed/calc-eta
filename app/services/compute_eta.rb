# frozen_string_literal: true

require "dry/monads/do"

class ComputeEta
  include Dry::Monads[:result, :do]

  Dry::Validation.load_extensions(:monads)

  attr_reader :validator, :car_locator, :arrival_predictor

  Location = Struct.new(:lat, :lng, keyword_init: true) do
    def cache_key
      [lat, lng].map { |v| format("%.6f", v) }.join(":") # https://en.wikipedia.org/wiki/Decimal_degrees#Precision
    end

    def coordinates
      to_h
    end
  end

  def initialize(validator = LocationValidator.new,
                 car_locator = LocateNearbyCars.new,
                 arrival_predictor = PredictArrival.new)
    @validator = validator
    @car_locator = car_locator
    @arrival_predictor = arrival_predictor
  end

  def call(params)
    location_params = yield validator.call(params)
    target_location = Location.new(**location_params.to_h)

    eta = CalcEta.cache.fetch(target_location.cache_key) do
      cars_coordinates = yield car_locator.call(**target_location.coordinates)
      cars_eta_array = yield arrival_predictor.call(target: target_location.coordinates, source: cars_coordinates)
      cars_eta_array.min
    end

    Success(eta.to_i)
  end
end
