# frozen_string_literal: true

require "dry/monads/do"

class ComputeEta
  include Dry::Monads[:result, :do]

  def initialize(car_locator = LocateNearbyCars.new, arrival_predictor = PredictArrival.new)
    @car_locator = car_locator
    @arrival_predictor = arrival_predictor
  end

  def call(params)
    location_params = yield validate(params)
    cars_coordinates = yield car_locator.call(**location_params)
    cars_eta_array = yield arrival_predictor.call(target: location_params, source: cars_coordinates)

    Success(cars_eta_array.min)
  end

  private

  attr_reader :car_locator, :arrival_predictor

  def validate(params)
    # TODO
    Success(params)
  end
end
