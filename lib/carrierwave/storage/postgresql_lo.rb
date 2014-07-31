# encoding: utf-8
module CarrierWave
  module Storage
    class PostgresqlLo < Abstract
      class File
        def initialize(uploader)
          @uploader = uploader
        end

        def url
          "/uploads/#{identifier}"
        end

        def read
          @uploader.model.transaction do
            lo = lo_manager.java_send :open, [Java::long], identifier
            bytes = lo.read(lo.size)
            lo.close
            String.from_java_bytes(bytes)
          end
        end

        def write(file)
          array_buf = java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(file.path))
          @uploader.model.transaction do
            lo = lo_manager.java_send :open, [Java::long, Java::int], identifier, Java::OrgPostgresqlLargeobject::LargeObjectManager::WRITE
            lo.truncate(0)
            lo.write(array_buf)
            size = lo.size
            lo.close
            size
          end
        end

        def delete
          lo_manager.java_send :unlink, [Java::long], identifier
        end

        def content_type
        end

        def file_length
          @uploader.model.transaction do
            lo = lo_manager.java_send :open, [Java::long], identifier
            size = lo.size
            lo.close
            size
          end
        end

        alias :size :file_length

        def connection
          @connection ||= @uploader.model.class.connection.raw_connection
        end

        def lo_manager
          @lo_manager ||= connection.connection.getLargeObjectAPI
        end

        def identifier
          @oid ||= @uploader.identifier.to_i
        end

        def original_filename
          identifier.to_s
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
        @oid ||= uploader.model.read_attribute(uploader.mounted_as) || lo_manager.createLO
      end

      def connection
        @connection ||= uploader.model.class.connection.raw_connection
      end

      def lo_manager
        @lo_manager ||= connection.connection.getLargeObjectAPI
      end
    end
  end
end
