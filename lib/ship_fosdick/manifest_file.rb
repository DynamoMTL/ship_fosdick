module ShipFosdick
  class ManifestFile
    attr_reader :key

    def initialize(key,
                   manifest_repository: ShipFosdick.bucket.objects)
      @key = key
      @manifest_repository = manifest_repository
    end

    def parse_content
      [].tap do |rows|
        s3_object.content.each_line do |line|
          next if line.blank? || line.match(/(Ext Order #|TRAILER RECORD|SKU)/)
          rows << ManifestRow.new(line)
        end
      end
    end

    private

    attr_reader :manifest_repository

    def s3_object
      manifest_repository.find(self.key)
    end

    class ManifestRow
      def initialize(data)
        @data = data
      end

      def shipment_number
        normalized_data[0]
      end

      def carrier
        normalized_data.last
      end

      def tracking_code
        normalized_data[3]
      end

      private

      attr_reader :data

      def normalized_data
        data.split("\t").map(&:strip)
      end
    end
  end
end
