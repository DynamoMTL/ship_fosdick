module ShipFosdick
  class ManifestFile
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def parse_content
      [].tap do |rows|
        s3_object.content.each_line do |line|
          next if line.blank? || line.match(/(Ext Order #|TRAILER RECORD|SKU)/)
          rows << line.split(' ')
        end
      end
    end

    def s3_object
      ShipFosdick.bucket.objects.find(self.key)
    end
  end
end
