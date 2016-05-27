module ShipFosdick
  class IndividualShipmentUpdater
    def self.update(record)
      shipment = ::Spree::Shipment.find_by(number: record[0].strip)
      target_state = "shipped"
      return if !shipment
      return if shipment.state == target_state

      tracking = record[3].strip

      shipment_attributes = { tracking: tracking }

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
end
