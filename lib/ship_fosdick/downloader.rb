module ShipFosdick
  class Downloader
    def initialize(bucket)
      @bucket = bucket
    end

    def download
      [].tap do |returned_content|
        objects.each do |object|
          next unless object.key.downcase.include?('ship')
          returned_content << object.content
        end
      end
    end

    def objects
      return bucket.objects.with_prefix(ShipFosdick.configuration.folder_prefix) if ShipFosdick.configuration.folder_prefix

      bucket.objects
    end

    private

    attr_reader :bucket

  end
end
