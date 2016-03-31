require 'spec_helper'

RSpec.describe ShipFosdick::Document::Shipment do
  let(:order) { create :order_with_line_items }
  let(:shipment) { order.shipments.first }
  let(:long_city) { 'InFactThisIsMoreThanTwelveCharacters' }
  let(:long_address1) { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' }

  it 'instantiates itself' do
    expect(described_class.new(shipment)).to be_truthy
  end

  describe '#to_xml' do
    subject{ described_class.new(shipment).to_xml }

    it 'converts the shipment to xml' do
      expect(subject).to include '<?xml version="1.0"?>'
    end

    it 'has a fosdick specific wrapper object' do
      expect(subject).to include 'UnitycartOrderPost'
    end

    it 'contains a transaction id' do
      expect(subject).to include 'TransactionID'
    end

    it 'has an order top level object' do
      expect(subject).to include '<Order>'
    end

    describe 'shipping address' do
      it 'concats the city name to 12 characters if greater than 12' do
        order.shipping_address.update_attribute(:city, long_city)
        expect(subject).to include long_city.slice(0..12)
      end

      it 'returns the correct Army Forces state for Americas' do
        order.shipping_address.state.update_attribute(:name, 'U.S. Armed Forces – Americas')
        expect(subject).to include 'AA'
      end

      it 'returns the correct Army Forces state for Europe' do
        order.shipping_address.state.update_attribute(:name, 'U.S. Armed Forces – Europe')
        expect(subject).to include 'AE'
      end

      it 'returns the correct Army Forces state for Europe' do
        order.shipping_address.state.update_attribute(:name, 'U.S. Armed Forces – Pacific')
        expect(subject).to include 'AP'
      end

      it 'returns a ShipStateOrder node for countries with states outside of the US' do
        order.shipping_address.country.update_attribute(:iso3, 'CAN')
        expect(subject).to include 'ShipStateOther'
      end

      it 'wraps a long address1 into address2' do
        order.shipping_address.update_attribute(:address1, long_address1)
        line1_xml = "<ShipAddress1>Lorem ipsum dolor sit amet, co</ShipAddress1>"
        line2_xml = "<ShipAddress2>nsectetur adipiscing elit., No</ShipAddress2>"
        expect(subject).to include line1_xml
        expect(subject).to include line2_xml
      end
    end

    describe 'items' do
      it 'has a list of order items' do
        expect(subject).to include '<Item>'
      end
    end
  end
end
