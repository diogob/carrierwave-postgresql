# encoding: utf-8

require 'carrierwave'
require 'carrierwave/storage/adapters/jdbc_connection'
require 'carrierwave/storage/adapters/pg_connection'
require 'carrierwave/storage/postgresql_lo'

module CarrierWave
  module Postgresql
  end
end

CarrierWave::Storage.autoload :PostgresqlLo, 'carrierwave/storage/postgresql_lo'
CarrierWave::Uploader::Base.storage_engines[:postgresql_lo] = "CarrierWave::Storage::PostgresqlLo"
