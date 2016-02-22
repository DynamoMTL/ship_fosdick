require 'spec_helper'
require 's3'

RSpec.describe 'Upload Shipment To S3', :slow do
  xit 'successfully uploads a shipment to s3' do
    # test the bucket isn't empty.
    # test the bucket has atleast one xml document
    # test the information in the xml document corresponds to the one order
    # wipe the bucket clean
  end
end
