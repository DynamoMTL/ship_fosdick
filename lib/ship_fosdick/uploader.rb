module ShipFosdick
  class Uploader
    def initialize(bucket)
      @bucket = bucket
    end

    def upload(name, content)
      upload_shipments(name, content)
    end

    private

    attr_reader :bucket

    def upload_shipments(name, content)
      object = bucket.objects.build(name)
      object.content = content
      object.save
    end
  end
end
