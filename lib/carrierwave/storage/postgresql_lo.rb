# encoding: utf-8
module CarrierWave
  module Storage
    class PostgresqlLo < Abstract
      class File
        attr_reader :path

        def initialize(uploader, oid)
          @oid = oid
          @uploader = uploader
        end

        def url
        end

        def read
          lo = connection.lo_open(@oid)
          content = connection.lo_read(lo, file_length)
          connection.lo_close(lo)
          content
        end

        def write(file)
          lo = connection.lo_open(@oid)
          size = connection.lo_write(lo, file.read)
          connection.lo_close(lo)
          size
        end

        def delete
        end

        def content_type
        end

        def file_length
          lo = connection.lo_open(@oid)
          size = connection.lo_lseek(lo, 0, 2)
          connection.lo_close(lo)
          size
        end

        alias :size :file_length

        def connection
          @connection ||= @uploader.model.connection.raw_connection
        end

      end

      def store!(file)
        raise "This uploader must be mounted in an ActiveRecord model to work" unless @uploader.model
      end

      def retrieve!(identifier)
      end
    end
  end
end
