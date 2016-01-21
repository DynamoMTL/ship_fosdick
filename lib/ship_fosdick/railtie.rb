if defined?(Rails)
  require 'rails'

  module ShipFosdick
    # Allow for configuration options like:
    # config.ship_fosdick.api_key = some_api_key
    class Railtie < Rails::Railtie
      config.ship_fosdick = ActiveSupport::OrderedOptions.new
    end
  end
end
