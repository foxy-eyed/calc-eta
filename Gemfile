# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "dotenv"
gem "dry-monads"
gem "faraday"
gem "hanami-api"
gem "hanami-validations", github: "hanami/validations", branch: "main"
gem "puma"
gem "rack"
gem "rake"

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-rspec"
end

group :test do
  gem "rspec"
  gem "simplecov", require: false
  gem "webmock"
end
