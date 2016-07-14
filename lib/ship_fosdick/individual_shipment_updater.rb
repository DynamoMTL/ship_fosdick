module ShipFosdick
  class IndividualShipmentUpdater
    class NoOrderError < RuntimeError; end
    class FailedUpdateError < StandardError; end

    def initialize(manifest_row,
                   shipment_repository: Spree::Shipment,
                   failed_update_error_factory: FailedUpdateError,
                   no_order_error_factory: NoOrderError)

      @manifest_row = manifest_row
      @shipment_repository = shipment_repository
      @failed_update_error_factory = failed_update_error_factory
      @no_order_error_factory = no_order_error_factory
    end

    def perform
      return unless can_update?

      raise_no_order_error unless shipment.order

      result = atomically do
        update_attributes and
          transition_state and
          update_order
      end || raise_failed_update_error
    end

    alias_method :update, :perform

    private

    attr_reader :failed_update_error_factory, :manifest_row,
      :no_order_error_factory, :shipment_repository

    def atomically(&block)
      ActiveRecord::Base.transaction(&block)
    end

    def can_update?
      shipment &&
        !shipment.shipped?
    end

    def raise_no_order_error
      raise no_order_error_factory,
        "No order associated with #{manifest_row.shipment_number}, which should be impossible."
    end

    def raise_failed_update_error
      raise failed_update_error_factory,
        "Updating shipment #{manifest_row.shipment_number} failed."
    end

    def shipment
      @_shipment ||=
        shipment_repository.find_by(number: manifest_row.shipment_number)
    end

    def transition_state
      shipment.ship
    end

    def update_attributes
      shipment.update(tracking: manifest_row.tracking_code)
    end

    def update_order
      shipment.order.update!
    end
  end
end
