module CarrierWave
  module Test
    module MockFiles
      def file_path( *paths )
        File.expand_path(File.join(File.dirname(__FILE__), '../fixtures', *paths))
      end

      def stub_file(filename, mime_type=nil, fake_name=nil)
        File.open(file_path(filename))
      end

      def stub_tempfile(filename, mime_type=nil, fake_name=nil)
        raise "#{file_path(filename)} file does not exist" unless File.exist?(file_path(filename))

        t = Tempfile.new(filename)
        FileUtils.copy_file(file_path(filename), t.path)

        allow(t).to receive(:local_path).and_return('')
        allow(t).to receive(:original_filename).and_return(filename || fake_name)
        allow(t).to receive(:content_type).and_return(mime_type)
        t
      end
    end
  end
end

RSpec.configure do |config|
  config.include CarrierWave::Test::MockFiles
end

