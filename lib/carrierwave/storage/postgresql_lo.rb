# encoding: utf-8
module CarrierWave
  module Storage
    class PostgresqlLo < Abstract
      class File
        attr_reader :path

        def initialize(uploader)
          @uploader = uploader
        end

        def url
        end

        def read
          @uploader.model.transaction do
            lo = connection.lo_open(oid)
            content = connection.lo_read(lo, file_length)
            connection.lo_close(lo)
            content
          end
        end

        def write(file)
          @uploader.model.transaction do
            @oid = connection.lo_creat
            lo = connection.lo_open(oid, ::PG::INV_WRITE)
            size = connection.lo_write(lo, file.read)
            connection.lo_close(lo)
            size
          end
        end

        def delete
        end

        def content_type
        end

        def file_length
          lo = connection.lo_open(oid)
          size = connection.lo_lseek(lo, 0, 2)
          connection.lo_close(lo)
          size
        end

        alias :size :file_length

        def connection
          @connection ||= @uploader.model.connection.raw_connection
        end

        def oid
          @oid ||= @uploader.identifier
        end

      end

      def store!(file)
        raise "This uploader must be mounted in an ActiveRecord model to work" unless @uploader.model
        stored = CarrierWave::Storage::PostgresqlLo::File.new(uploader)
        stored.write(file)
        stored
      end

      def retrieve!(identifier)
      end
    end
  end
end
