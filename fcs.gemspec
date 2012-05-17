# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fcs/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mark Quezada"]
  gem.email         = ["mark@mirthlab.com"]
  gem.description   = %q{Library for interacting with FreeSWITCH via event socket.}
  gem.summary       = %q{Library for interacting with FreeSWITCH via event socket.}
  gem.homepage      = "https://github.com/mirthlab/fcs"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fcs"
  gem.require_paths = ["lib"]
  gem.version       = FCS::VERSION
end
