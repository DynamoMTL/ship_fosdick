module ShipFosdick
  class Downloader
    def initialize(bucket)
      @bucket = bucket
    end

    def download
      [].tap do |returned_files|
        bucket.objects.each do |object|
          next unless object.key.downcase.include?('shp')
          returned_files << object.content
        end
      end
    end

    private

    attr_reader :bucket

  end
end
