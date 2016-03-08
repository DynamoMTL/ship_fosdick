require 'spec_helper'
require 's3'

RSpec.describe ShipFosdick::UploadFactory, :slow do
  let!(:order) { create :order_ready_to_ship }
  let(:service) { S3::Service.new(:access_key_id => ENV.fetch('AWS_ACCESS_KEY_ID'), 
                                  :secret_access_key => ENV.fetch('AWS_SECRET_ACCESS_KEY')) }
  let(:bucket) { service.buckets.find(ENV.fetch('S3_BUCKET')) }

  before :each do
    wipe(bucket)
  end

  it 'instantiates itself successfully' do
    expect(described_class.new).to be_truthy
  end

  describe '#call' do
    subject { described_class.new.call }

    it 'responds successfully to the message' do
      expect(subject).to be_truthy
    end

    it 'successfully uploads the shipment to s3' do
      subject
      expect(bucket.objects.count).to eq 1
      expect(bucket.objects.first.content).to_not be_empty
    end
  end

  def wipe(bucket)
    bucket.objects.each do |object|
      object.destroy
    end
  end
end
