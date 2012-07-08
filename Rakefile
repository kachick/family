gem 'hoe', '~> 3.0.6'
require 'hoe'
require 'fileutils'

Hoe.plugin :newgem

$hoe = Hoe.spec 'family' do
  developer 'Kenichi Kamiya', 'kachick1+ruby@gmail.com'
  self.rubyforge_name       = name
  require_ruby_version '>= 1.9.2'
  dependency 'validation', '~> 0.0.3', :runtime
  dependency 'yard', '~> 0.8.2.1', :development
  dependency 'declare', '~> 0.0.4', :development
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each {|t|load t}
