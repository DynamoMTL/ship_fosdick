ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rails/all'
require 'rspec/rails'
require 'pry-byebug'
require 'factory_girl'
require 'ship_fosdick'
require 'ffaker'
require 'dotenv'
require 'vcr'
Dotenv.load
FactoryGirl.find_definitions

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |f| require f }

require 'spree/testing_support/factories'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :rspec
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  DatabaseCleaner.strategy = :truncation

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

ShipFosdick.configure do |config|
  config.aws_secret = ENV.fetch('AWS_SECRET_ACCESS_KEY')
  config.aws_key = ENV.fetch('AWS_ACCESS_KEY_ID')
  config.bucket = ENV.fetch('S3_BUCKET')
  config.client_name = "client_name"
  config.client_code = "client_code"
  config.adcode = "adcode"
  config.test_mode = true
  config.address_max_length = ENV.fetch('FOSDICK_ADDRESS_MAX_LENGTH', 30)
end
