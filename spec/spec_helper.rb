ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rails/all'
require 'rspec/rails'
require 'pry-byebug'
require 'factory_girl'
require 'ship_fosdick'
require 'ffaker'
FactoryGirl.find_definitions

require 'spree/testing_support/factories'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods 
  config.mock_with :rspec
  DatabaseCleaner.strategy = :truncation

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
