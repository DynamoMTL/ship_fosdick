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
          next if line.blank? || line.match(/(Ext Order #|TRAILER RECORD|SKU)/)
          record = line.split(' ')
          update_shipment(record)
        end
      end
    end

    private

    attr_reader :files

    def update_shipment(record)
      shipment = ::Spree::Shipment.find_by(number: record[0].strip)
      return true if !shipment

      tracking = record[3].strip

      shipment_attributes = { tracking: tracking }

      target_state = "shipped"
      # check if a state transition is required, and search for correct event to fire
      transition = nil
      if shipment.state != target_state
        unless transition = shipment.state_transitions.detect { |trans| trans.to == target_state }
          raise ShipmentUpdateError, "Cannot transition shipment from current state: '#{shipment.state}' to requested state: '#{target_state}', no transition found."
        end
      end

      #update attributes
      shipment.update(shipment_attributes)

      #fire state transition
      if transition
        shipment.fire_state_event(transition.event)
      end

      shipment.save!

      # Ensure Order shipment state and totals are updated.
      # Note: we call update_shipment_state separately from update in case order is not in completed.
      shipment.order.updater.update_shipment_state
      shipment.order.updater.update
    end
  end

  class ShipmentUpdateError < StandardError; end
end
