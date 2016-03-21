require 'spec_helper'

RSpec.describe ShipFosdick::Sender do

  let(:order) { create :order_with_line_items }
  let(:shipment) { order.shipments.first }
  let(:shipment_xml) do
    # for the specific test environment the shipping_method is just empty.
    shipment.shipping_method.update_column(:name,"")
    ShipFosdick::Document::Shipment.new(shipment).to_xml
  end

  it 'should send a shipment' do
    VCR.use_cassette('send_shipment') do
      response = ShipFosdick::Sender.send_doc(shipment_xml)
      expect(response['SuccessCode']).to eql "True"
      expect(response['OrderNumber']).to be_present
    end
  end
end
