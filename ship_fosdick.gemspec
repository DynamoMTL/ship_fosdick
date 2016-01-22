# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ship_fosdick/version'

Gem::Specification.new do |spec|
  spec.name          = 'ship_fosdick'
  spec.version       = ShipFosdick::VERSION
  spec.authors       = ['Braden']
  spec.email         = ['braden@godynamo.com']

  spec.summary       = %( Ship to fosdick using Spree or Solidus )
  spec.description   = %( Fosdick uses a flat file structure and AWS to ship shipments and send updates. This manages the ftp/aws interaction for shipping products in your Spree or Solidus storefront )
  spec.homepage      = 'https://github.com/DynamoMTL/ship_fosdick'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'spree_core', '~> 2.4'
  spec.add_dependency 'aws-sdk'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.0'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'sqlite3'
end
