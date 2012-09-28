# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "carrierwave-postgresql"
  gem.homepage = "http://diogob.github.com/carrierwave-postgresql/"

  gem.license = "MIT"
  gem.summary = %Q{Use PostgreSQL large objects (AKA BLOBs) to store your files inside the database}
  gem.description = %Q{This gem adds to carrierwave a storage facility which will use the PostgreSQL's oid datatype to reference a large object residing in the databse. It supports up to 2GB files, though it's better suited for smaller ones. Makes life easier for fast prototyping and put all your data in the same place, allows one backup for all your data and file storage in heroku servers.}
  gem.email = "diogo@biazus.me"
  gem.authors = ["Diogo Biazus"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "carrierwave-postgresql #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
