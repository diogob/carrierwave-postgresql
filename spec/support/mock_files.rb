module CarrierWave
  module Test
    module MockFiles
      def file_path( *paths )
        File.expand_path(File.join(File.dirname(__FILE__), '../fixtures', *paths))
      end

      def stub_file(filename, mime_type=nil, fake_name=nil)
        f = File.open(file_path(filename))
        return f
      end

      def stub_tempfile(filename, mime_type=nil, fake_name=nil)
        raise "#{file_path(filename)} file does not exist" unless File.exist?(file_path(filename))

        t = Tempfile.new(filename)
        FileUtils.copy_file(file_path(filename), t.path)

        t.stub(:local_path => "",
                :original_filename => filename || fake_name,
                :content_type => mime_type)

        return t
      end
    end
  end
end

RSpec.configure do |config|
  config.include CarrierWave::Test::MockFiles
end

