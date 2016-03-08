module ShipFosdick
  class DownloadFactory
    def call
      update_shipments(processable_files).process
    end

    private

    def service
      @_service ||=  S3::Service.new(:access_key_id => ENV.fetch('AWS_ACCESS_KEY_ID'), 
                                     :secret_access_key => ENV.fetch('AWS_SECRET_ACCESS_KEY')) 
    end

    def bucket
      service.buckets.find(ENV.fetch('S3_BUCKET'))
    end

    def processable_files
      ShipFosdick::Downloader.new(bucket).download
    end

    def update_shipments(content)
      ShipFosdick::ShipmentUpdater.new(content)
    end
  end
end
