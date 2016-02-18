# encoding: utf-8
module CarrierWave
  module Storage
    class PostgresqlLo < Abstract
      class File
        if defined?(JRUBY_VERSION)
          include CarrierWave::Storage::Adapters::JDBCConnection
        else
          include CarrierWave::Storage::Adapters::PGConnection
        end

        def initialize(uploader)
          @uploader = uploader
        end

        def url
          "/#{@uploader.model.class.name.underscore.gsub('/', '_')}_#{@uploader.mounted_as.to_s.underscore}/#{identifier}"
        end

        def content_type
        end

        alias :size :file_length

        def connection
          @connection ||= @uploader.model.class.connection.raw_connection
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
        @oid = identifier
        CarrierWave::Storage::PostgresqlLo::File.new(uploader)
      end

      def identifier
        @oid ||= create_large_object
      end

      def connection
        @connection ||= uploader.model.class.connection.raw_connection
      end

      private
      def create_large_object
        if defined?(JRUBY_VERSION)
          connection.connection.getLargeObjectAPI.createLO
        else
          connection.lo_creat
        end
      end
    end
  end
end
