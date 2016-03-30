module ShipFosdick
  module Downloader
    extend self

    def download
      objects.map(&:key).select do |key|
        key.downcase.include?('ship') && key.downcase.ends_with?('txt')
      end
    end

    private
    def objects
      prefix = ShipFosdick.configuration.folder_prefix
      return ShipFosdick.bucket.objects(prefix: prefix) if prefix
      ShipFosdick.bucket.objects
    end
  end
end
