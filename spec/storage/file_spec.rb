require 'spec_helper'

describe CarrierWave::Storage::PostgresqlLo::File do
  let(:test_model){ Test.new }
  let(:uploader){ double('an uploader', model: test_model, identifier: identifier, mounted_as: :file) }
  let(:file){ CarrierWave::Storage::PostgresqlLo::File.new(uploader) }
  let(:tempfile){ stub_tempfile('test.jpg', 'application/xml') }
  let(:file_content){ 'this is stuff' }
  let(:identifier) {
    if defined?(JRUBY_VERSION)
      Test.connection.raw_connection.connection.getLargeObjectAPI.createLO
    else
      Test.connection.raw_connection.lo_creat 
    end
  }

  describe "#delete" do
    it("should delete the file using the lo interface") do
      ActiveRecord::Base.transaction {
        file.write(tempfile)
        file.delete
      }
      expect { file.read }.to raise_error(PG::Error)
    end
  end

  describe "#url" do
    subject{ file.url }
    it{ ActiveRecord::Base.transaction {should == "/test_file/#{identifier}"} }

    context "on a namespaced model" do
      let(:test_model){ Namespace::Test.new }
      it { 
        ActiveRecord::Base.transaction {
          should == "/namespace_test_file/#{identifier}"
        }
      }
    end
  end

  describe "#write" do
    it("should write the file using the lo interface") do
      ActiveRecord::Base.transaction {
        expect(file.write(tempfile)).to eq file_content.length
      }
    end

    it("should change file size after a write is called twice on the same identifier") do
      ActiveRecord::Base.transaction {
        file.write(stub_tempfile('another_test.jpg', 'application/xml'))
        file.write(tempfile)
      }
      expect(ActiveRecord::Base.transaction {file.read}).to eq file_content
    end
  end

  describe "#file_length" do
    it("should return the file size") do
      ActiveRecord::Base.transaction {file.write(tempfile)}
      expect(ActiveRecord::Base.transaction {file.file_length}).to eq file_content.length
    end
  end

  describe "#read" do
    it("should read the file using the lo interface") do
      ActiveRecord::Base.transaction {file.write(tempfile)}
      expect(ActiveRecord::Base.transaction {file.read}).to eq file_content
    end
  end
end
