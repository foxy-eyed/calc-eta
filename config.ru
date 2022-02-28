# frozen_string_literal: true

require File.expand_path("config/application", __dir__)

use Rack::Reloader if ENV["RACK_ENV"] == "development"

run CalcEta::App.new
