# carrierwave-postgresql

This gem adds to [CarrierWave](https://github.com/jnicklas/carrierwave/) a storage facility which will use the PostgreSQL's oid datatype to reference a large object residing in the databse. It supports up to 2GB files, though it's better suited for smaller ones. Makes life easier for fast prototyping and put all your data in the same place, allows one backup for all your data and file storage in heroku servers.

For more information on PostgreSQL Large Objects you can take a look at the [oficial docs](http://www.postgresql.org/docs/9.2/static/largeobjects.html)

## Installation

Install the latest release:

    gem install carrierwave-postgresql

Require it in your code:

    require 'carrierwave/postgresql'

Or, in Rails you can add it to your Gemfile:

    gem 'carrierwave-postgresql'

## Getting Started

First, this extension assumes 2 important things:

 * You are using CarrierWave with ActiveRecord
 * Your database is PostgreSQL

If you fill the above requirements then you can proceed to the wonderful land of database stored files!

Start off by generating an uploader:

	rails generate uploader Avatar

this should give you a file in:

	app/uploaders/avatar_uploader.rb

You can configure Carrierwave to use PostgreSQL Large Objects instead of the filesystem.
Just change your uploader storage to `:postgresql_lo` as in:

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :postgresql_lo
end
```

Add an oid column to the model you want to mount the uploader on:

```ruby
add_column :users, :avatar, :oid
```

Open your model file and mount the uploader:

```ruby
class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
end
```

Now you can cache files by assigning them to the attribute, they will
automatically be stored sinside the database using the Large Object facility when the record is saved.

```ruby
u = User.new
u.avatar = params[:file]
u.avatar = File.open('somewhere')
u.save!
u.avatar.url # => '/url/to/file.png'
u.avatar.current_path # => 'path/to/file.png'
u.avatar.identifier # => 'file.png'
```

For more info on CarrierWave take a look at the main [Carrierwave repository](https://raw.github.com/jnicklas/carrierwave/).


## How to stream the files from the web server

Since carrierwave-postgresql doesn't make the files available via HTTP, you'll need to stream
them yourself. In Rails for example, you could use the `send_data` method.

The url that will be available from the field where you mounted the uploader will be the model name followed by the attribute name and with the oid as the resource id.

For instance, in the user's avatar example the url for an image with 1 as it's oid would be `/user_avatar/1`

You can retrieve the file contents using the following code:

```ruby
u = User.new
u.avatar = params[:file]
u.avatar = File.open('somewhere')
u.save!
u.avatar.file.read
```

## Contributing to carrierwave-postgresql
 
 * Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
 * Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
 * Fork the project.
 * Start a feature/bugfix branch.
 * Commit and push until you are happy with your contribution.
 * Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
 * Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Acknowledgments

This code is largely based on [carrierwave-mongoid](https://github.com/jnicklas/carrierwave-mongoid)
I wanted to thank (jnicklas)[https://github.com/jnicklas] for all the open source code and for the great (and extensible) architecture of CarrierWave.

## Copyright

Copyright (c) 2012 Diogo Biazus. See LICENSE.txt for
further details.

