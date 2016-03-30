require 'spec_helper'

RSpec.describe "Feature Integration Spec", :slow do

  let(:service) { S3::Service.new(:access_key_id => ShipFosdick.configuration.aws_key,
                                 :secret_access_key => ShipFosdick.configuration.aws_secret) }
  let(:bucket) { service.buckets.find(ShipFosdick.configuration.bucket) }

  let(:manifest) { TestShipment.new }
  let!(:order) { create :order_ready_to_ship }

  describe "full live test" do
    before :each do
      wipe_files
      upload_file
    end

    it 'updates valid shipments if in the shipping manifests' do

      # 1) Download the manifest files from s3
      manifest_files = ShipFosdick::Downloader.download

      # 2) Run the ShipmentsUpdater for each manifest file
      manifest_files.each do |manifest_file|
        ShipFosdick::ShipmentsUpdater.new(manifest_file).process
      end
      expect(order.shipments.first.state).to eq 'shipped'
    end
  end

  def wipe_files
    bucket.objects.each do |obj|
      obj.destroy
    end
  end

  def upload_file
    fosdick_file = bucket.objects.build('838383TESTDLYSHIP.txt')
    fosdick_file.content = manifest.generate(order)
    fosdick_file.save
  end
end
