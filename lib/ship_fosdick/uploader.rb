module ShipFosdick
  class Uploader
    def initialize(bucket)
      @bucket = bucket
    end

    def upload(name, file)
      orders = bucket.objects
      upload(file, orders)
    end

    private

    attr_reader :bucket

    def upload(file, orders)
      orders.write(
        file: file,
        acl: :public_read
      )
    end
  end
end
