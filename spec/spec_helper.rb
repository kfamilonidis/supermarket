require 'bundler'
require 'supermarket'

Bundler.require

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

require 'rspec/expectations'

RSpec::Matchers.define :have_a_price_of do |expected|
  match do |actual|
    actual.price == expected
  end
end