module ShipFosdick
  module Downloader
    extend self

    def download
      objects.select do |object|
        object.key.downcase.include?('ship') && object.key.downcase.ends_with?('txt')
      end.map(&:key)
    end

    private
    def objects
      prefix = ShipFosdick.configuration.folder_prefix
      return ShipFosdick.bucket.objects(prefix: prefix) if prefix
      ShipFosdick.bucket.objects
    end
  end
end
