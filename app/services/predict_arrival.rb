# frozen_string_literal: true

class PredictArrival
  include Dry::Monads[:result]

  def call(target:, source:)
    response = WheelyApi.predict(target: target, source: source)
    Success(response)
  rescue WheelyApi::Error => e
    Failure(e.message)
  end
end
