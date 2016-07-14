require 'spec_helper'

RSpec.describe ShipFosdick::IndividualShipmentUpdater do
  class MockException < StandardError; end

  let(:shipment_repository) { double(:shipment_repository) }
  let(:failed_update_error_factory) { MockException }
  let(:no_order_error_factory) { MockException }

  subject(:updater) do
    described_class.new(manifest_row,
                        shipment_repository: shipment_repository,
                        failed_update_error_factory: failed_update_error_factory,
                        no_order_error_factory: no_order_error_factory)
  end

  let(:manifest_row) { double(:manifest_row, shipment_number: '1234', tracking_code: 'ABCD1234') }
  let(:order) { double(:order) }
  let(:shipment) { double(:shipment, order: order) }

  before do
    allow(ActiveRecord::Base).to receive(:transaction).and_yield.and_return(true)
    allow(shipment_repository).to receive(:find_by).and_return(shipment)
  end

  describe "#perform" do
    before do
      allow(order).to receive(:update!)

      allow(shipment).to receive(:update) { true }
      allow(shipment).to receive(:shipped?) { false }
      allow(shipment).to receive(:ship) { true }
    end

    context "atomically" do
      before do
        expect(ActiveRecord::Base).to receive(:transaction)
      end

      it "updates the shipment's 'tracking' attribute" do
        expect(shipment).to receive(:update).with(tracking: 'ABCD1234')

        perform!
      end

      it "transitions the shipment to the 'shipped' state" do
        expect(shipment).to receive(:ship)

        perform!
      end

      it "updates the shipment's order" do
        expect(order).to receive(:update!)

        perform!
      end
    end

    context "when a matching shipment cannot be found" do
      before do
        allow(shipment_repository).to receive(:find_by).and_return(nil)
      end

      it "returns falsey" do
        expect(perform!).to be_falsey
      end
    end

    context "when the shipment is already in the 'shipped' state" do
      before do
        allow(shipment).to receive(:shipped?).and_return(true)
      end

      it "returns" do
        expect(perform!).to be_falsey
      end
    end

    context "when the shipment has no order" do
      before do
        allow(shipment).to receive(:order).and_return(nil)
      end

      it "raises an exception" do
        cause = ->{ perform! }

        expect(&cause).to raise_error(MockException)
      end
    end

    context "when the shipment cannot be updated" do
      before do
        allow(ActiveRecord::Base).to receive(:transaction).and_yield.and_return(false)
      end

      context "with a failed attribute update" do
        before do
          allow(shipment).to receive(:update).and_return(false)
        end

        it "raises an exception" do
          cause = ->{ perform! }

          expect(&cause).to raise_error(MockException)
        end
      end

      context "when the shipment cannot be transitioned to the 'shipped' state" do
        before do
          allow(shipment).to receive(:ship).and_return(false)
        end

        it "raises an exception" do
          cause = ->{ perform! }

          expect(&cause).to raise_error(MockException)
        end
      end

      context "when the order fails to update" do
        before do
          allow(order).to receive(:update!).and_return(false)
        end

        it "raises an exception" do
          cause = ->{ perform! }

          expect(&cause).to raise_error(MockException)
        end
      end
    end

    def perform!
      updater.perform
    end
  end
end
