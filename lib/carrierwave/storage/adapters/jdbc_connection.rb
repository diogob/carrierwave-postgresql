# encoding: utf-8
module CarrierWave
  module Storage
    module Adapters
      module JDBCConnection
        def read
          ::ActiveRecord::Base.transaction do
            lo = lo_manager.java_send :open, [Java::long], identifier
            bytes = lo.read(lo.size)
            lo.close
            String.from_java_bytes(bytes)
          end
        end

        def write(file)
          array_buf = java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(file.path))
          ::ActiveRecord::Base.transaction do
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

        def file_length
          ::ActiveRecord::Base.transaction do
            lo = lo_manager.java_send :open, [Java::long], identifier
            size = lo.size
            lo.close
            size
          end
        end

        private
        def lo_manager
          @lo_manager ||= connection.connection.getLargeObjectAPI
        end
      end
    end
  end
end
