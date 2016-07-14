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

      # 1) Download the keys from s3
      keys = ShipFosdick::Downloader.download

      # so we can create a worker for each key!
      # 2) Run the ShipmentsUpdater for each manifest file
      keys.each do |key|
        ShipFosdick::ShipmentsUpdater.new(ShipFosdick::ManifestFile.new(key)).process
      end

      expect(order.shipments.first).to have_attributes(state: "shipped",
                                                       tracking: "9274899999898079474850")
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
