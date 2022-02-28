# frozen_string_literal: true

require_relative "environment"
require_relative "boot"

module CalcEta
  class App < Hanami::API
    get "/eta" do
      [200, json(status: "success")]
    end
  end
end
