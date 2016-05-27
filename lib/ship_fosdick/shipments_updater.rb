module ShipFosdick
  # Reads in the content from the ManifestFile and updates
  # mentioned shipments as shipped and updates the
  # tracking number if available.
  class ShipmentsUpdater
    attr_reader :manifest_file

    def initialize(manifest_file)
      @manifest_file = manifest_file
    end

    # The line here from fosdick is generally the
    # following seperated by space chars:
    # ext order # (shipment number) at index 0
    # ship_date at index 1
    # carrer code at index 2
    # tracking # at index 3
    # fosdick order number at index 4
    # job number at index 5
    # run date at index 6
    def process
      rows = manifest_file.parse_content
      rows.each do |record|
        update_shipment(record)
      end
    end

    private
    def update_shipment(record)
      updater.new(record).perform
    end

    def updater
      return ShipFosdick::IndividualShipmentUpdater unless ShipFosdick.configuration.shipment_updater_class

      ShipFosdick.configuration.shipment_updater_class.constantize
    end
  end

  class ShipmentUpdateError < StandardError; end
end
