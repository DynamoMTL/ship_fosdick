require 'spec_helper'

RSpec.describe ShipFosdick::IndividualShipmentUpdater do

  let!(:order) { create :order_ready_to_ship }
  let(:tracking) { '01234' }
  let!(:shipment) { order.shipments.first }
  let!(:manifest_row) { [shipment.number, "012122016","hm",tracking] }

  subject(:updater) { described_class.new(manifest_row) }

  describe "#perform" do
    before do
      updater.perform
    end

    it "updates the shipment's attributes" do
      expect(shipment.reload.tracking).to eql tracking
    end

    it "transitions the shipment to the 'shipped' state" do
      expect(shipment.reload.state).to eql 'shipped'
    end

    it "updates the shipment's order" do
      expect(order.reload.shipment_state).to eql 'shipped'
    end

    context "when a matching shipment cannot be found" do
      let!(:manifest_row) { [shipment.number + "FOO", "012122016","hm",tracking] }

      it "returns" do
        expect(updater.perform).to be_nil
      end
    end

    context "when the shipment is already in the 'shipped' state" do
      before do
        shipment.update_attribute(:state, 'shipped')
      end
      it "returns" do
        expect(updater.perform).to be_nil
      end
    end

    context "when the shipment cannot be transitioned to the 'shipped' state" do
      before do
        shipment.update_attribute(:state, 'pending')
      end

      it "raises an exception" do
        expect { updater.perform }.to raise_error(ShipFosdick::ShipmentUpdateError, "Cannot transition shipment from current state: 'pending' to requested state: 'shipped', no transition found.")
      end
    end
  end
end
