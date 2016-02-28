module ShipFosdick
  class UploadFactory
    def initialize
      @content = ''
    end

    def call
      xml_shipments
      upload_shipments
    end

    private

    attr_reader :content

    def service
      @_service ||=  S3::Service.new(:access_key_id => ENV.fetch('AWS_ACCESS_KEY_ID'), 
                                     :secret_access_key => ENV.fetch('AWS_SECRET_ACCESS_KEY')) 
    end

    def bucket
      service.buckets.find(ENV.fetch('S3_BUCKET'))
    end

    def eligible_shipments
      ::Spree::Shipment.where('state = ? AND created_at > ?', 'ready', 1.day.ago)
    end

    def xml_shipments
      eligible_shipments.each do |shipment|
        content << ShipFosdick::Document::Shipment.new(shipment, {}).ship
      end
    end

    def upload_shipments
      ShipFosdick::Uploader
        .new(bucket)
        .upload('fosdick_shipments.xml', content)
    end
  end
end
