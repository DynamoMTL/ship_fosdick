# ShipFosdick

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ship_fosdick', github: 'DynamoMTL/ship_fosdick'
```

And then execute:
```shell
$ bundle
```

## Usage

### Setup

create an initializer `config/initializer/fosdick.rb` and add the configuration like this:

```ruby
ShipFosdick.configure do |config|
  config.aws_secret = ENV.fetch('AWS_SECRET_ACCESS_KEY')
  config.aws_key = ENV.fetch('AWS_ACCESS_KEY_ID')
  config.bucket = ENV.fetch('S3_BUCKET')
  config.client_name = ENV.fetch('CLIENT_NAME')
  config.client_code = ENV.fetch('CLIENT_CODE')
  config.adcode = ENV.fetch('ADCODE')
end
```

There is also a `test_mode` config option that is set to `false` by default.
To enabled test mode add it to the configuration:

```ruby
config.test_mode = true
```

### Sender

To send a `Spree::Shipment` object to Fosdick we need to make a Fosdick XML file
so for a `Spree::Shipment` instance named `shipment` it will look like this:
```ruby
shipment_xml = ShipFosdick::Document::Shipment.new(shipment).to_xml
```
next we need to push that xml document to the Fosdick endpoint using the `Sender` class

```ruby
response = ShipFosdick::Sender.send_doc(shipment_xml)
```

with a succesfull push to Fosdick the `send_doc` method will return a `Hash` with the mapping details between the `shipment` and Fosdick
```ruby
{
  external_id: 'H23424242',
  order_number: "903423534242"
}
```

when there is an error response the gem will raise a `ShipFosdick::SendError` with
the response error message.

### Download

Fosdick, once shipments have been shipped, deposit a text file back into the S3 bucket.

To download and process those files you need to do something like this:

```ruby
  # download all the keys from S3 that contain 'ship' and '.txt' in the key
  # we return only the keys so it's easy to feed each key into a worker
  keys = ShipFosdick::Downloader.download
  keys.each do |key|
    MySampleWorker.perform_async(key)
  end


  # The worker could be something like this:
  class MySampleWorker
    include Sidekiq::Worker
    sidekiq_options retry: false, backtrace: true

    def perform(key)
      manifest_file = ShipFosdick::ManifestFile.new(key)
      ShipFosdick::ShipmentsUpdater.new(manifest_file).process

      # move or delete the s3 object. When updating the already shipped shipments will be ignored.
      # so they could stay in the bucket, although cleaning up the bucket is recommended.
    end
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dynamomtl/ship_fosdick.
This project is intended to be a safe,
welcoming space for collaboration,
and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
All changed items are recorded in the CHANGELOG.md

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
