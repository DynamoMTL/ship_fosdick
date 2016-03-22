require 'spree_core'
require 's3'

Dir[File.dirname(__FILE__) + '/ship_fosdick/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/ship_fosdick/document/*.rb'].each {|file| require file }

module ShipFosdick
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :aws_secret, :aws_key, :bucket, :client_name, :adcode, :client_code, :test_mode
    def config
      {
        aws_secret: aws_secret,
        aws_key: aws_key,
        bucket: bucket,
        client_name: client_name,
        adcode: adcode,
        client_code: client_code,
        test_mode: test_mode
      }
    end
  end

end
