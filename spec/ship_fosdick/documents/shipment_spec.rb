require 'spec_helper'

RSpec.describe ShipFosdick::Document::Shipment do
  let(:order) { create :order_with_line_items }
  let(:shipment) { order.shipments.first }
  let(:long_city) { 'InFactThisIsMoreThanTwelveCharacters' }

  it 'instantiates itself' do
    expect(described_class.new(shipment, ShipFosdick.configuration.config)).to be_truthy
  end

  describe '#ship' do
    subject{ described_class.new(shipment, ShipFosdick.configuration.config).ship }

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
    end

    describe 'items' do
      it 'has a list of order items' do
        expect(subject).to include '<Item>'
      end
    end
  end
end
