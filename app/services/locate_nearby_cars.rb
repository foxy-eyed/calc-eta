# frozen_string_literal: true

class LocateNearbyCars
  include Dry::Monads[:result]

  DEFAULT_CARS_LIMIT = 5

  def call(lat:, lng:)
    response = WheelyApi.cars(lat: lat,
                              lng: lng,
                              limit: ENV.fetch("CARS_LIMIT", DEFAULT_CARS_LIMIT))
    return Failure("No available cars nearby") if response.empty?

    Success(response)
  rescue WheelyApi::Error => e
    Failure(e.message)
  end
end
