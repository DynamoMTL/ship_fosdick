require 'spec_helper'

RSpec.describe ShipFosdick::IndividualShipmentUpdater, :focus do
  let(:manifest_row) { double(:manifest_row) }

  subject(:updater) { described_class.new(manifest_row) }

  describe "#perform" do
    it "updates the shipment's attributes"

    it "transitions the shipment to the 'shipped' state"

    it "updates the shipment's order"

    context "when a matching shipment cannot be found" do
      it "returns"
    end

    context "when the shipment is already in the 'shipped' state" do
      it "returns"
    end

    context "when the shipment cannot be transitioned to the 'shipped' state" do
      it "raises an exception"
    end
  end
end
