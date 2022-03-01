# frozen_string_literal: true

require "simplecov_profile"
SimpleCov.start "custom_profile"

ENV["RACK_ENV"] = "test"

require "webmock/rspec"
require File.expand_path("../config/application", __dir__)
Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

WebMock.disable_net_connect!(allow_localhost: true)
RedisCache.fake!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  Kernel.srand config.seed

  config.include LoadFixture

  config.before do
    CalcEta.cache.reset!
  end
end
