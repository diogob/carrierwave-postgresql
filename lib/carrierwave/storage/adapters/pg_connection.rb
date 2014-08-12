# encoding: utf-8
module CarrierWave
  module Storage
    module Adapters
      module PGConnection
        def read
          @uploader.model.transaction do
            lo = connection.lo_open(identifier)
            content = connection.lo_read(lo, file_length)
            connection.lo_close(lo)
            content
          end
        end

        def write(file)
          @uploader.model.transaction do
            lo = connection.lo_open(identifier, ::PG::INV_WRITE)
            connection.lo_truncate(lo, 0)
            size = connection.lo_write(lo, file.read)
            connection.lo_close(lo)
            size
          end
        end

        def delete
          connection.lo_unlink(identifier)
        end

        def file_length
          @uploader.model.transaction do
            lo = connection.lo_open(identifier)
            size = connection.lo_lseek(lo, 0, 2)
            connection.lo_close(lo)
            size
          end
        end
      end
    end
  end
end
