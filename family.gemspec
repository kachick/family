require File.expand_path('../lib/family/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.description   = %q{Homogeneous Array}
  gem.summary       = %q{Homogeneous Array}
  gem.homepage      = 'https://github.com/kachick/family'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features|family)/})
  gem.name          = 'family'
  gem.require_paths = ['lib']
  gem.version       = Family::VERSION.dup # dup for https://github.com/rubygems/rubygems/commit/48f1d869510dcd325d6566df7d0147a086905380#-P0

  gem.required_ruby_version = '>= 1.9.2'
  gem.add_runtime_dependency 'validation', '~> 0.0.3'
  gem.add_development_dependency 'declare', '~> 0.0.5.a'
  gem.add_development_dependency 'yard', '>= 0.8.2.1'
end

