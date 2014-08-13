$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "carrierwave-postgresql"
  s.version     = "0.1.4"
  s.date        = "2013-11-19"
  s.authors     = ["Diogo Biazus"]
  s.email       = ["diogo@biazus.me"]
  s.homepage    = "https://github.com/diogob/carrierwave-postgresql"
  s.summary     = "Carrierwave storing files in a PostgreSQL database"
  s.description = "This gem adds to carrierwave a storage facility which will use the PostgreSQL's oid datatype to reference a large object residing in the databse. It supports up to 2GB files, though it's better suited for smaller ones. Makes life easier for fast prototyping and put all your data in the same place, allows one backup for all your data and file storage in heroku servers."

  s.files = Dir["{lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]

  s.add_dependency "carrierwave"

  s.add_development_dependency "activerecord", "~> 4.0.1"
  if defined?(JRUBY_VERSION)
    s.add_development_dependency "activerecord-jdbcpostgresql-adapter"
  else
    s.add_development_dependency "pg"
  end
  s.add_development_dependency "rspec"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
end
