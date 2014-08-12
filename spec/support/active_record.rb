require 'active_record'

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
      :adapter  => 'postgresql',
      :database => 'carrierwave_test',
      :username => 'postgres',
      :password => 'password',
      :host     => 'localhost')
    ActiveRecord::Base.connection.execute "DROP TABLE IF EXISTS tests;"
    ActiveRecord::Base.connection.execute "CREATE TABLE tests (file oid);"
  end
end

class Test < ActiveRecord::Base
end

module Namespace
  class Test < ActiveRecord::Base
  end
end
