require 'spec_helper'

RSpec.describe ShipFosdick::Downloader do
  let(:download_bucket) { double :bucket, name: 'fosdick' }
  
  it 'instantiates itself with a bucket name' do
    expect(described_class.new(download_bucket.name)).to an_instance_of described_class
  end
end
