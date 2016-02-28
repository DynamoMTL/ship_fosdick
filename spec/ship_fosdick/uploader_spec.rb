require 'spec_helper'

RSpec.describe ShipFosdick::Uploader do
  let(:upload_bucket) { double :bucket, name: 'fosdick' }

  it 'instantiates itself with a bucket name' do
    expect(described_class.new(upload_bucket)).to an_instance_of described_class
  end

  describe '#upload' do
    let(:upload_content) { double :fosdick_content }
    let(:upload_instance) { double :s3_reference }
    subject { described_class.new(upload_bucket) }

    before :each do
      expect(upload_bucket).to receive_message_chain(:objects, :build) { upload_instance }
      expect(upload_instance).to receive(:content=).with(upload_content) { upload_content }
      expect(upload_instance).to receive(:save) { true }
    end

    it 'responds to #upload with a file' do
      expect(subject.upload('csv_file', upload_content)).to be_truthy
    end
  end
end
