require 'spec_helper'
require 's3'

RSpec.describe ShipFosdick::ShipmentUpdater do
  let!(:order) { create :order_ready_to_ship }
  let(:tracking) { '01234' }
  let(:content) { "#{order.shipments.first.number} 012122016 hm #{tracking}" }
  let(:s3_object) { S3::Object }
  let!(:downloaded_files) { [s3_object] } 

  it 'instantiates itself properly' do
    expect(described_class.new(downloaded_files)).to be_truthy
  end

  describe '#process' do
    subject{ described_class.new(downloaded_files) }

    before :each do
      expect(s3_object).to receive(:content) { content }
      subject.process
    end

    it 'updates the shipments as shipped' do
      expect(order.shipments.first.state).to eq 'shipped'
    end

    it 'updates the shipment with the tracking code provided by fosdick' do
      expect(order.shipments.first.tracking).to eq tracking
    end
  end
end
