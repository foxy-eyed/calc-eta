# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "dotenv"
gem "faraday"
gem "hanami-api"
gem "puma"
gem "rack"

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-rspec"
end

group :test do
  gem "rspec"
  gem "webmock"
end
