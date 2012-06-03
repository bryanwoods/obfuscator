# -*- encoding: utf-8 -*-
require File.expand_path('../lib/obfuscator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bryan Woods"]
  gem.email         = ["bryanwoods4e@gmail.com"]
  gem.description   = "A clean, friendly API for obfuscating slightly sensitive data from a Rails application"
  gem.summary       = "Obfuscate provides an easy way to quickly overwrite slightly sensitive data from a Rails application for debugging or developing off a database dump"
  gem.homepage      = "http://github.com/bryanwoods/obfuscator"
  gem.licenses      = ["MIT"]

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "obfuscator"
  gem.require_paths = ["lib"]
  gem.version       = Obfuscator::VERSION
  gem.add_dependency "activerecord"
  gem.add_dependency "faker"
end
