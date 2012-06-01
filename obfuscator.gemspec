# -*- encoding: utf-8 -*-
require File.expand_path('../lib/obfuscator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bryan Woods"]
  gem.email         = ["bryanwoods4e@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://github.com/bryanwoods/obfuscator"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "obfuscator"
  gem.require_paths = ["lib"]
  gem.version       = Obfuscator::VERSION
  gem.licence = "MIT"
  gem.add_dependency "active_record"
  gem.add_dependency "faker"
end
