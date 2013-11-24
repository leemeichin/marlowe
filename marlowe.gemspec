# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marlowe/version'

Gem::Specification.new do |spec|
  spec.name          = "marlowe"
  spec.version       = Marlowe::VERSION
  spec.authors       = ["Lee Machin"]
  spec.description   = %q{Show Travis build statuses on an LED display in real time}
  spec.summary       = %q{Show Travis build statuses on an LED display in real time}
  spec.homepage      = "https://leemachin.github.io/marlowe"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "travis", "~> 1.6.3.travis.381.4"
  spec.add_runtime_dependency "led_board"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
