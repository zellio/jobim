# coding: utf-8

$:.unshift File.expand_path("../lib", __FILE__)
require 'quincy/version'

Gem::Specification.new do |spec|
  spec.name          = "quincy"
  spec.version       = Quincy::VERSION

  spec.authors       = ["Zachary Elliott"]
  spec.email         = ["zach@nyu.edu"]

  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}

  spec.homepage      = "https://github.com/zellio/quincy"

  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency 'yard', "~> 0.8"
  spec.add_development_dependency 'redcarpet', "~> 3.0"
  spec.add_development_dependency 'github-markup', "~> 0.7"

  spec.add_runtime_dependency "thin", "~> 1.5"
end