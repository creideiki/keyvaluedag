#-*- ruby -*-
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kvdag/version'

Gem::Specification.new do |spec|
  spec.name	= 'kvdag'
  spec.version  = KVDAG::VERSION
  spec.summary	= 'Directed Acyclic Graph for Key-Value searches'
  spec.description	= spec.summary
  spec.homepage    = 'https://github.com/saab-simc-admin/keyvaluedag'
  spec.authors	= ['Calle Englund']
  spec.email	= ['calle.englund@saabgroup.com']
  spec.license	= 'MIT'

  spec.has_rdoc	= true

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.platform	= Gem::Platform::RUBY
  spec.required_ruby_version = '~>2'
  spec.add_runtime_dependency 'activesupport', '~>4'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-collection_matchers", "~> 1.1.2"

end
