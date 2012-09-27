# encoding: utf-8
module CarrierWave
  module Storage
    class PostgresqlLo < Abstract
      def store!(file)
        raise "This uploader must be mounted in an ActiveRecord model to work" unless @uploader.model
      end

      def retrieve!(identifier)
      end
    end
  end
end
