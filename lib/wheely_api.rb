# frozen_string_literal: true

class WheelyApi
  class Error < StandardError; end

  class << self
    def cars(lat:, lng:, limit:)
      new.request(:get, "cars", lat: lat, lng: lng, limit: limit)
    end

    def predict(target:, source:)
      new.request(:post, "predict", target: target, source: source)
    end

    def basic_error
      Error
    end
  end

  def request(verb, path, params = {})
    raise Error, "[WheelyApi]: not configured!" unless ENV["WHEELY_API_URL"]

    response = connection.send(verb, path, params)
    status = response.status
    body = response.body
    raise Error, "[WheelyApi]: #{status} — #{body}" unless status == 200

    body
  rescue Faraday::Error => e
    raise Error, "[WheelyApi]: #{e.message}"
  end

  private

  def connection
    @connection ||= Faraday.new(ENV["WHEELY_API_URL"]) do |faraday|
      faraday.request :retry, { retry_statuses: [500], interval: 0.05 }
      faraday.request :json
      faraday.response :json
    end
  end
end
