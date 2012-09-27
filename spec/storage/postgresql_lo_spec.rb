require 'spec_helper'

describe CarrierWave::Storage::PostgresqlLo do
  let(:storage){ CarrierWave::Storage::PostgresqlLo.new(uploader) }
  let(:file){ stub_tempfile('test.jpg', 'application/xml') }
  describe "#store!" do
    context "when we do not have it mounted" do
      let(:uploader){ mock('an uploader', :model => nil) }
      it("should raise error if not mounted"){ ->{ storage.store!(file) }.should raise_error("This uploader must be mounted in an ActiveRecord model to work") }
    end
  end
end
