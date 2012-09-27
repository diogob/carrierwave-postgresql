# encoding: utf-8
module CarrierWave
  module Storage
    class PostgresqlLo < Abstract
      class File
        def initialize(uploader)
          @uploader = uploader
        end

        def url
          "/#{@uploader.model.class.name.downcase}_#{@uploader.mounted_as.downcase}/#{identifier}"
        end

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
          @uploader.model.transaction do
            lo = connection.lo_open(identifier)
            size = connection.lo_lseek(lo, 0, 2)
            connection.lo_close(lo)
            size
          end
        end

        alias :size :file_length

        def connection
          @connection ||= @uploader.model.connection.raw_connection
        end

        def identifier
          @oid ||= @uploader.identifier
        end

      end

      def store!(file)
        raise "This uploader must be mounted in an ActiveRecord model to work" unless uploader.model
        stored = CarrierWave::Storage::PostgresqlLo::File.new(uploader)
        stored.write(file)
        stored
      end

      def retrieve!(identifier)
        raise "This uploader must be mounted in an ActiveRecord model to work" unless uploader.model
        CarrierWave::Storage::PostgresqlLo::File.new(uploader)
      end

      def identifier
        @oid ||= uploader.model.read_attribute(uploader.mounted_as) || connection.lo_creat
      end

      def connection
        @connection ||= uploader.model.connection.raw_connection
      end
    end
  end
end
