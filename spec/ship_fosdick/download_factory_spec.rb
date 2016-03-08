require 'spec_helper'

RSpec.describe ShipFosdick::DownloadFactory, :slow do
  let(:service) { S3::Service.new(:access_key_id => ENV.fetch('AWS_ACCESS_KEY_ID'), 
                                  :secret_access_key => ENV.fetch('AWS_SECRET_ACCESS_KEY')) }
  let(:bucket) { service.buckets.find(ENV.fetch('S3_BUCKET')) }
  let(:manifest) { TestShipment.new }
  let!(:order) { create :order_ready_to_ship }

  it 'instantiates itself successfully' do
    expect(described_class.new).to be_truthy
  end
  
  describe "#call" do
    subject { described_class.new.call }

    before :each do
      wipe_files
      upload_file
      subject
    end

    it 'updates valid shipments if in the shipping manifests' do
      expect(order.shipments.first.state).to eq 'shipped'
    end
  end

  def wipe_files
    bucket.objects.each do |obj|
      obj.destroy
    end
  end

  def upload_file
    xls_file = bucket.objects.build('838383TESTDLYSHP.txt')
    xls_file.content = manifest.generate(order)
    xls_file.save
  end
end
