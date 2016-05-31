module ShipFosdick
  class IndividualShipmentUpdater
    class InvalidTransitionError < StandardError; end

    def initialize(manifest_row,
                   shipment_repository: Spree::Shipment,
                   invalid_transition_error_factory: InvalidTransitionError)

      @manifest_row = ManifestRow.new(manifest_row)
      @shipment_repository = shipment_repository
      @invalid_transition_error_factory = invalid_transition_error_factory
    end

    def perform
      return unless can_update?

      raise_invalid_transition_error unless shipment.can_ship?

      update_attributes
      transition_state
      update_order
    end

    alias_method :update, :perform

    private

    attr_reader :invalid_transition_error_factory, :manifest_row,
      :shipment_repository

    def can_update?
      shipment &&
        !shipment.shipped?
    end

    def raise_invalid_transition_error
      raise invalid_transition_error_factory,
        "Cannot transition shipment from current state: '#{shipment.state}' to requested state: 'shipped', no transition found."
    end

    def shipment
      shipment_repository.find_by(number: manifest_row.shipment_number)
    end

    def transition_state
      shipment.ship
    end

    def update_attributes
      shipment.update(tracking: manifest_row.tracking_code)
    end

    def update_order
      shipment.order.updater.update_shipment_state
      shipment.order.updater.update
    end

    class ManifestRow < Struct.new(:row)
      def shipment_number
        row[0]
      end

      def tracking_code
        row[3]
      end
    end
  end
end
