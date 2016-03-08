module ShipFosdick
  # Reads in the Array of Files from the
  # ShipFosdick::Downloader class and updates 
  # mentioned shipments as shipped and updates the 
  # tracking number if available.
  class ShipmentUpdater
    def initialize(files)
      @files = files
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
      files.each do |file|
        file.each_line do |line|
          next if line.blank? || line.match(/Ext Order #/)
          @line = line.split(' ')
          update_shipment
        end
      end
    end

    private 

    attr_reader :files, :line

    def update_shipment
      return true if !updating_shipment
      updating_shipment.update_attribute(:tracking, line[3])
      updating_shipment.ship! 
    end

    def updating_shipment
      @_updating_shipment ||= ::Spree::Shipment.find_by(number: line[0])
    end
  end
end
