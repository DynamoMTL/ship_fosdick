module ShipFosdick
  class Downloader

    def self.download
      [].tap do |returned_content|
        objects.each do |object|
          next unless object.key.downcase.include?('ship')
          next unless object.key.downcase.include?('.txt')
          returned_content << ShipFosdick::ManifestFile.new(object.key)
        end
      end
    end

    private
    def self.objects
      prefix = ShipFosdick.configuration.folder_prefix
      return ShipFosdick.bucket.objects(prefix: prefix) if prefix
      ShipFosdick.bucket.objects
    end
  end
end
