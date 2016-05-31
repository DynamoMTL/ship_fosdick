require 'spec_helper'

RSpec.describe ShipFosdick::ShipmentsUpdater do
  let!(:order) { create :order_ready_to_ship }

  let(:manifest_file) { ShipFosdick::ManifestFile.new("01245SHIP.txt") }

  subject(:updater) { described_class.new(manifest_file) }

  let(:manifest_row) { double(:manifest_row, shipment_number: number, tracking_code: tracking) }

  let(:tracking) { '01234' }
  let(:number) { order.shipments.first.number }

  it 'instantiates itself properly' do
    expect(updater).to be_truthy
  end

  describe '#process' do
    before :each do
      allow(manifest_file).to receive(:parse_content) { [manifest_row] }
    end

    before(:each) do
      updater.process
    end

    it 'updates the shipments as shipped' do
      expect(order.shipments.first.state).to eq 'shipped'
    end

    it 'updates the shipment with the tracking code provided by fosdick' do
      expect(order.shipments.first.tracking).to eq tracking
    end
  end
end
