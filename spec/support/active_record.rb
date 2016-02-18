require 'active_record'

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
      :adapter  => 'postgresql',
      :database => 'carrierwave_test',
      :username => 'chris',
      :password => '',
      :host     => 'localhost')
    ActiveRecord::Base.connection.create_table :tests, force: true do |t|
      t.column :file, :oid
    end
  end
end
require 'carrierwave'
require 'carrierwave/orm/activerecord'

class LoUploader < CarrierWave::Uploader::Base
  storage :postgresql_lo
end

class Test < ActiveRecord::Base
  include CarrierWave::ActiveRecord
  mount_uploader :my_file, LoUploader, mount_on: :file
end

module Namespace
  class Test < ActiveRecord::Base
  end
end
