module ShipFosdick
  module Downloader
    extend self

    def download
      [].tap do |returned_content|
        objects.each do |object|
          next unless object.key.downcase.include?('ship')
          next unless object.key.downcase.include?('.txt')
          returned_content << object.key
        end
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
