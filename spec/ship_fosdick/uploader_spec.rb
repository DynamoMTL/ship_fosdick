require 'spec_helper'

RSpec.describe ShipFosdick::Uploader do
  let(:upload_bucket) { double :bucket, name: 'fosdick' }

  it 'instantiates itself with a bucket name' do
    expect(described_class.new(upload_bucket.name)).to an_instance_of described_class
  end

  describe '#upload' do
    let(:upload_file) { double :fosdick_csv }
    let(:upload_instance) { double :s3_reference }
    subject { described_class.new(upload_bucket.name) }

    before :each do
      allow(upload_bucket).to receive(:objects) { upload_instance }
      allow_any_instance_of(described_class).to receive(:upload) { true }
    end

    it 'responds to #upload with a file' do
      expect(subject.upload('csv_file', upload_file)).to be_truthy
    end
  end
end
