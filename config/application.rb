# frozen_string_literal: true

require_relative "environment"
require_relative "boot"

module CalcEta
  class App
    def self.instance
      @instance ||= Hanami::Router.new do
        get "/eta", to: CalcEta::Api.new
        get "/documentation", to: CalcEta::Documentation.new
      end
    end
  end
end
