require 'rubygems'
require 'spec/rake/spectask'
require 'spec/version'

desc 'Default: run specs.'
task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--colour', '--format', 'profile', '--timeout', '20']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "rfc822"
    gemspec.summary = "RFC822 compatible email validation and MX record check"
    gemspec.description = "RFC822 compatible email validation and MX record check"
    gemspec.email = "dimitrij@blacksquaremedia.com"
    gemspec.homepage = "http://github.com/dim/rfc822"
    gemspec.authors = ["Dimitrij Denissenko"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
