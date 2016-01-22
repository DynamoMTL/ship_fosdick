require 'spree_core'
require 'ship_fosdick/version'
require 'ship_fosdick/railtie'
require 'ship_fosdick/engine'
require 'ship_fosdick/uploader'

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
