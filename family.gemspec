# coding: us-ascii

require File.expand_path('../lib/family/version', __FILE__)
lib_name = 'family'.freeze
require "./lib/#{lib_name}/version"

Gem::Specification.new do |gem|
  # specific

  gem.description   = %q{Homogeneous Array}
  gem.summary       = gem.description.dup
  gem.homepage      = 'https://github.com/kachick/family'
  gem.license       = 'MIT'
  gem.name          = lib_name.dup
  gem.version       = Family::VERSION.dup

  gem.required_ruby_version = '>= 2.0.0'
  gem.add_runtime_dependency 'validation', '~> 0.0.7'

  gem.add_development_dependency 'declare', '~> 0.0.6'
  gem.add_development_dependency 'yard', '>= 0.8.7.6', '< 0.9'
  gem.add_development_dependency 'rake', '>= 10', '< 20'
  gem.add_development_dependency 'bundler', '>= 1.10', '< 2'

  if RUBY_ENGINE == 'rbx'
    gem.add_dependency 'rubysl', '~> 2.1'
  end

  # common

  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
