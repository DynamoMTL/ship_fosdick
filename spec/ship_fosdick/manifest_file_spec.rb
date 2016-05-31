require 'spec_helper'

RSpec.describe ShipFosdick::ManifestFile, :focus do
  let(:manifest_repository) { double(:manifest_repository) }

  subject(:manifest_file) { described_class.new(key) }

  let(:key) { double(:key) }

  let(:raw_manifest_data) do
    File.read("spec/support/test_shipment.txt")
  end

  before do
    allow(ShipFosdick).to receive_message_chain("bucket.objects") { manifest_repository }
  end

  describe "#parse_content" do
    let(:s3_object) { double(:s3_object, content: raw_manifest_data) }

    before do
      allow(manifest_repository).to receive(:find).and_return(s3_object)
    end

    it "returns parsed manifest-rows" do
      manifest_file.parse_content.tap do |parsed|
        expect(parsed.count).to eq 2
        expect(parsed).to all(be_kind_of(Array))
      end
    end
  end
end
