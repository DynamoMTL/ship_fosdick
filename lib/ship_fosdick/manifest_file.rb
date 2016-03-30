module ShipFosdick
  class ManifestFile
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def s3_object
      begin
        ShipFosdick.bucket.objects.find(self.key)
      rescue S3::Error::NoSuchKey
      end
    end

  end
end
