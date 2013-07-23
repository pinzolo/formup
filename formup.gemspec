# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formup/version'

Gem::Specification.new do |spec|
  spec.name          = "formup"
  spec.version       = Formup::VERSION
  spec.authors       = ["pinzlo"]
  spec.email         = ["pinzolo@gmail.com"]
  spec.description   = %q{formup is rubygem for creating data model based form class}
  spec.summary       = %q{Create data model based form class}
  spec.homepage      = "https://github.com/pinzolo/formup"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activemodel"#, "~>3.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
