# frozen_string_literal: true

require File.expand_path("config/application", __dir__)

use Rack::Reloader if ENV["RACK_ENV"] == "development"
use Rack::Static, urls: ["/docs"]

run CalcEta::App.instance
