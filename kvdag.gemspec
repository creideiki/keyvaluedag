#-*- ruby -*-
Gem::Specification.new do |s|
  s.name	= 'kvdag'
  s.summary	= 'Direct Acyclical Graph for KeyValue searches'
  s.description	= File.read(File.join(File.dirname(__FILE__), 'README.md'))
  s.homepage    = 'https://github.com/saab-simc-admin/keyvaluedag'
  s.version	= '0.1.1'
  s.author	= 'Calle Englund'
  s.email	= 'calle.englund@saabgroup.com'
  s.license	= 'MIT'

  s.platform	= Gem::Platform::RUBY
  s.required_ruby_version = '~>2'
  s.add_runtime_dependency 'activesupport', '~>4'
  s.files	= [ 'README.md', 'LICENSE' ]
  s.files	+= Dir['lib/**/*.rb']
  s.executables	= []
  s.test_files	= Dir['test/test*.rb']
  s.has_rdoc	= true
end
