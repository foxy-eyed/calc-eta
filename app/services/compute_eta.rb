# frozen_string_literal: true

require "dry/monads/do"

class ComputeEta
  include Dry::Monads[:result, :do]

  Dry::Validation.load_extensions(:monads)

  attr_reader :validator, :car_locator, :arrival_predictor

  def initialize(validator = LocationValidator.new,
                 car_locator = LocateNearbyCars.new,
                 arrival_predictor = PredictArrival.new)
    @validator = validator
    @car_locator = car_locator
    @arrival_predictor = arrival_predictor
  end

  def call(params)
    location_params = yield validator.call(params)
    cars_coordinates = yield car_locator.call(**location_params.to_h)
    cars_eta_array = yield arrival_predictor.call(target: location_params.to_h, source: cars_coordinates)

    Success(cars_eta_array.min)
  end
end
