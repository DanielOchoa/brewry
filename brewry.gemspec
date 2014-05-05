require './lib/brewry/version'

Gem::Specification.new do |s|
  s.name        = 'Brewry'
  s.version     = Brewry::VERSION
  s.summary     = 'Brewry provides an interface to the BreweryDB API.'
  s.description =  'Brewry provides an interface to the BreweryDB API. Instead of returning a struct or some other Brewry instance, it returns a hash that can quickly be inserted into ActiveRecord. It also allows you to replace the keys for certain results such as key so you can keep track of them with your own id\'s.'
  s.authors     = ['Daniel Ochoa']
  s.email       = 'dannytenaglias@gmail.com'
  s.files       = ['lib/brewry.rb']
  s.homepage    = 'http://danielochoa.info'
  s.license     = 'MIT'
  gem.required_ruby_version = '>= 1.9'

  s.add_dependency 'httparty', '~> 0.13.1'
end
