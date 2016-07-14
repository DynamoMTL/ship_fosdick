require 'spec_helper'

RSpec.describe ShipFosdick::ManifestFile do
  let(:manifest_repository) { double(:manifest_repository) }

  subject(:manifest_file) do
    described_class.new(key,
                        manifest_repository: manifest_repository)
  end

  let(:key) { double(:key) }

  let(:raw_manifest_data) do
    File.read("spec/support/test_shipment.txt")
  end

  describe "#parse_content" do
    let(:s3_object) { double(:s3_object, content: raw_manifest_data) }

    before do
      allow(manifest_repository).to receive(:find).and_return(s3_object)
    end

    it "returns parsed manifest-rows" do
      manifest_file.parse_content.tap do |parsed|
        expect(parsed.count).to eq 2
        expect(parsed).to all have_attributes(
          shipment_number: a_string_starting_with("H"),
          tracking_code: a_string_matching(/\w+/),
          carrier: a_string_matching(/\w+/)
        )
      end
    end
  end
end
