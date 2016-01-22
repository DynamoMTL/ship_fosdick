ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rails/all'
require 'rspec/rails'
require 'ship_fosdick'
require 'pry-byebug'


RSpec.configure do |config|
  config.mock_with :rspec
end
