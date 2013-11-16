# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'catobills/version'

Gem::Specification.new do |spec|
  spec.name          = "catobills"
  spec.version       = Catobills::VERSION
  spec.authors       = ["Derek Willis"]
  spec.email         = ["dwillis@gmail.com"]
  spec.description   = %q{Wrapper for Cato's Deep Bills API}
  spec.summary       = %q{Extracts XML markup from Cato's Deep Bills Project}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "oj"
  spec.add_dependency "ox"
  spec.add_dependency "httparty"
end
