# frozen_string_literal: true

module CalcEta
  class Api
    include Dry::Monads[:result]

    def call(env)
      case ComputeEta.new.call(env["router.params"])
      in Success[value]
        [200, headers, json(eta: value)]
      in Failure[Dry::Validation::Result => result]
        [422, headers, json(errors: result.errors.to_h)]
      in Failure[error]
        [500, headers, json(error: error)]
      end
    end

    private

    def headers
      { "Content-Type" => "application/json" }
    end

    def json(object)
      [JSON.generate(object)]
    end
  end
end
