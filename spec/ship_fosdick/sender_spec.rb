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

  context "with error on xml" do
    let(:shipment_xml) do
      ShipFosdick::Document::Shipment.new(shipment).to_xml
    end

    it "will raise an exception" do
      VCR.use_cassette('send_shipment_with_error') do
        expect{ ShipFosdick::Sender.send_doc(shipment_xml) }.to raise_error(ShipFosdick::SendError, /{"SuccessCode"=>"False", "ErrorCode"=>"Invalid", "Errors"=>{"Error"=>"Unknown Shipping Method: UPS Ground"}, "ExternalID"=>"H78438053373"}/)
      end
    end
  end

end
