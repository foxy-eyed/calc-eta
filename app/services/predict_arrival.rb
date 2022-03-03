# frozen_string_literal: true

class PredictArrival
  include Dry::Monads[:result]

  attr_reader :data_provider

  def initialize(data_provider: WheelyApi)
    @data_provider = data_provider
  end

  def call(target:, source:)
    response = data_provider.predict(target: target, source: source)
    Success(response)
  rescue data_provider.basic_error => e
    Failure(e.message)
  end
end
