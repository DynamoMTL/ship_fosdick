require 'rspec/rails'
require 'ship_fosdick'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
end
