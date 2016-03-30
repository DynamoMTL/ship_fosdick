require 'spec_helper'

RSpec.describe ShipFosdick::Downloader do
  let(:download_bucket) { double :bucket, name: 'fosdick' }

  describe '#download' do
    let(:s3_object1) { double :s3_object, key: '20202SHIP.txt', content: 'file_content' }
    let(:s3_object2) { double :s3_object, key: 'kat_pic', content: 'pic_content' }
    let(:file_list) { [s3_object1, s3_object2] }

    before :each do
      allow(ShipFosdick).to receive(:bucket) { download_bucket }
      allow(download_bucket).to receive(:objects) { file_list }
    end

    subject{ described_class.download }

    it 'returns an array of ManifestFiles' do
      expect(subject).to be_an Array
    end

    it 'only returns file objects that are from fosdick' do
      expect(subject.length).to eq 1
      expect(subject.first).to be_an ShipFosdick::ManifestFile
      expect(subject.first.key).to eql '20202SHIP.txt'
    end
  end
end
