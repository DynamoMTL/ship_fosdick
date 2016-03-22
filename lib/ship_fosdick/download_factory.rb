module ShipFosdick
  class DownloadFactory
    def call
      update_shipments(processable_files).process
    end

    private

    def service
      @_service ||=  S3::Service.new(:access_key_id => ShipFosdick.configuration.aws_key,
                                     :secret_access_key => ShipFosdick.configuration.aws_secret)
    end

    def bucket
      service.buckets.find(ShipFosdick.configuration.bucket)
    end

    def processable_files
      ShipFosdick::Downloader.new(bucket).download
    end

    def update_shipments(content)
      ShipFosdick::ShipmentUpdater.new(content)
    end
  end
end
