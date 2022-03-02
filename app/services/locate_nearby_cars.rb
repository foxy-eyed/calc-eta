# frozen_string_literal: true

class LocateNearbyCars
  include Dry::Monads[:result]

  DEFAULT_CARS_LIMIT = 5

  attr_reader :data_provider

  def initialize(data_provider: WheelyApi)
    @data_provider = data_provider
  end

  def call(lat:, lng:)
    response = data_provider.cars(lat: lat, lng: lng, limit: ENV.fetch("CARS_LIMIT", DEFAULT_CARS_LIMIT))
    return Failure("No available cars nearby") if response.empty?

    Success(response)
  rescue data_provider.basic_error => e
    Failure(e.message)
  end
end
