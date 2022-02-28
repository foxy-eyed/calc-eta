# frozen_string_literal: true

require File.expand_path("config/application", __dir__)

require "rake"

# rubocop
require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop)

# rspec
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

task(:lint).clear.enhance(%i[rubocop])
task(:default).clear.enhance(%i[lint spec])
