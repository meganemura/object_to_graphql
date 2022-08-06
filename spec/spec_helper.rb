# frozen_string_literal: true

if ENV["CI"] == "true"
  require "simplecov"
  require "simplecov-html"
  require "simplecov-lcov"

  SimpleCov.start do
    enable_coverage :branch
  end
  # SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter
  ])
end

require "object_to_graphql"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
