# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree/version'

Gem::Specification.new do |spec|
  spec.name          = "spree"
  spec.version       = Spree::VERSION
  spec.authors       = ["Ryan Bigg"]
  spec.email         = ["radarlistener@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "money", "6.1.1"
  spec.add_dependency "monetize", "0.3.0"
  spec.add_dependency "activesupport", "4.1.2"
  spec.add_dependency "activemodel", "4.1.2"
  spec.add_dependency "active_model_serializers", "0.8.1"
  spec.add_dependency "virtus", "1.0.2"
  spec.add_dependency "inflecto", "0.0.2"
  spec.add_dependency "redis", "3.1.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '3.0.0'
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
end
