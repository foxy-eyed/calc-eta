# frozen_string_literal: true

require_relative "environment"
require_relative "boot"

module CalcEta
  class App < Hanami::API
    include Dry::Monads[:result]

    get "/eta" do
      case ComputeEta.new.call(params)
      in Success[value]
        [200, json(eta: value)]
      in Failure[error]
        [500, json(error: error)]
      end
    end
  end
end
