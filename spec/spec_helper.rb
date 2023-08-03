# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
SimpleCov.minimum_coverage 100
require_relative '../lib/easy_access_gpt'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
