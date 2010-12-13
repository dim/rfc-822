require 'rubygems'
require 'rake'
require 'rspec/mocks/version'
require 'rspec/core/rake_task'


RSpec::Core::RakeTask.new(:spec)

desc 'Default: run specs.'
task :default => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "rfc-822"
    gemspec.summary = "RFC822 compatible email validation and MX record check"
    gemspec.description = "RFC822 compatible email validation and MX record check"
    gemspec.email = "dimitrij@blacksquaremedia.com"
    gemspec.homepage = "http://github.com/dim/rfc-822"
    gemspec.authors = ["Dimitrij Denissenko"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
