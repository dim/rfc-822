# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.name        = "rfc-822"
  s.summary     = "RFC822 compatible email validation and MX record check"
  s.description = "RFC822 compatible email validation and MX record check"
  s.version     = "0.3.0"

  s.authors     = ["Dimitrij Denissenko"]
  s.email       = "dimitrij@blacksquaremedia.com"
  s.homepage    = "http://github.com/dim/rfc-822"

  s.require_path = 'lib'
  s.files        = Dir['LICENSE', 'README.*', 'init.rb', 'lib/**/*']
  s.test_files   = Dir['spec/**/*']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end

