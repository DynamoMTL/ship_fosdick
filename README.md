# ShipFosdick

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ship_fosdick'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ship_fosdick

## Usage

### Download

Fosdick, once shipments have been shipped, deposit a text file back into the S3 bucket.
There is a simple, rake runable factory that wraps the logic to do the following:

1. Download the content from these shipment manifests.
1. Parse this info into arrays of strings
1. Utilize [specific parts of the array][1] to update relevant shipments
1. Profit?

## Setup

Most Solidus and Spree stores will be running Paperclip.
This, at the moment relies on the S3 environment variables that should be set if running Paperclip:

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
S3_BUCKET
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

[1]: https://github.com/DynamoMTL/ship_fosdick/blob/master/lib/ship_fosdick/shipment_updater.rb#L11-L19
