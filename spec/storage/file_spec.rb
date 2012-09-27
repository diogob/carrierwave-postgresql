require 'spec_helper'

describe CarrierWave::Storage::PostgresqlLo::File do
  let(:test_model){ Test.new }
  let(:uploader){ mock('an uploader', :model => test_model) }
  let(:file){ CarrierWave::Storage::PostgresqlLo::File.new(uploader, 0) }
  let(:tempfile){ stub_tempfile('test.jpg', 'application/xml') }

  describe "#write" do
    before do
      file.connection.should_receive(:lo_open).with(0).and_return(1)
      file.connection.should_receive(:lo_close).with(1)
      file.connection.should_receive(:lo_write).with(1, "this is stuff").and_return(42)
    end
    it("should write the file using the lo interface"){ file.write(tempfile).should == 42 }
  end

  describe "#file_length" do
    before do
      file.connection.should_receive(:lo_open).with(0).and_return(1)
      file.connection.should_receive(:lo_close).with(1)
      file.connection.should_receive(:lo_lseek).with(1, 0, 2).and_return(42)
    end
    it("should return the file size"){ file.file_length.should == 42 }
  end

  describe "#read" do
    before do
      file.connection.should_receive(:lo_open).with(0).and_return(1)
      file.connection.should_receive(:lo_close).with(1)
      file.should_receive(:file_length).and_return(42)
      file.connection.should_receive(:lo_read).with(1, 42).and_return('file content')
    end

    it("should read the file using the lo interface"){ file.read.should == 'file content' }
  end
end
