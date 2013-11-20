# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arf/version'

Gem::Specification.new do |spec|
  spec.name          = "arf"
  spec.version       = Arf::VERSION
  spec.authors       = ["Lee Machin"]
  spec.description   = %q{Give developers their moment of fame (or shame) on an LED board}
  spec.summary       = %q{Give developers the praise they deserve (or unwanted attention they probably don't) by showing when they break or fix a build. For funsies.}
  spec.homepage      = "leemachin.github.io/arf"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "travis"
  spec.add_runtime_dependency "led_board"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
