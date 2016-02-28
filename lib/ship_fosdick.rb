require 'spree_core'
require 's3'

Dir[File.dirname(__FILE__) + '/ship_fosdick/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/ship_fosdick/document/*.rb'].each {|file| require file }

# Fosdick integration entry point.
# Will check to see if Rails confuration is available.
# Including bootstrapping all needed files for your shipping pleasure
module ShipFosdick
  def self.configure(&block)
    if block_given?
      block.call(ShipFosdick::Railtie.config.ship_fosdick)
    else
      ShipFosdick::Railtie.config.ship_fosdick
    end
  end
end
