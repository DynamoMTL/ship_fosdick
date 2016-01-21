require 'ship_fosdick/version'

# Fosdick integration entry point.
# Will check to see if Rails and a confuration is available.
# Including bootstrapping all needed files for your shipping pleasure
module ShipFosdick
  if defined?(Rails)
    def self.configure(&block)
      if block_given?
        block.call(ShipFosdick::Railtie.config.ship_fosdick)
      else
        ShipFosdick::Railtie.config.ship_fosdick
      end
    end
  else
    def self.config
      @@config ||= OpenStruct.new()
      @@config
    end
  end
end
