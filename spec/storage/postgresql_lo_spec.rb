require 'spec_helper'

describe CarrierWave::Storage::PostgresqlLo do
  let(:storage){ CarrierWave::Storage::PostgresqlLo.new(uploader) }
  let(:file){ stub_tempfile('test.jpg', 'application/xml') }
  let(:test_model){ Test.new }

  describe "#retrieve!" do
    context "when we do not have it mounted" do
      let(:uploader){ double('an uploader', model: nil) }
      it("should raise error if not mounted"){ expect{ storage.store!(file) }.to raise_error("This uploader must be mounted in an ActiveRecord model to work") }
    end

    context "when we have it mounted" do
      let(:uploader){ double('an uploader', model: test_model, mounted_as: :file) }
      let(:lo){ storage.store!(file) }
      before do
        allow(uploader).to receive(:identifier) do
          storage.identifier
        end
      end
      subject{ storage.retrieve! lo.identifier }
      its(:read){ is_expected.to eq 'this is stuff' }
    end
  end

  describe "#store!" do
    context "when we do not have it mounted" do
      let(:uploader) { double('an uploader', model: nil) }
      it("should raise error if not mounted") { expect{ storage.store!(file) }.to raise_error("This uploader must be mounted in an ActiveRecord model to work") }
    end

    context 'when we have it mounted' do
      let(:uploader) { double('an uploader', model: test_model) }
      let(:lo) { storage.store!(file) }
      before do
        allow(uploader).to receive(:identifier) do
          storage.identifier
        end
      end
      subject { lo }
      its(:read) { is_expected.to eq 'this is stuff' }
    end
  end

  it 'test with mounted as' do
    test = Test.create!(my_file: file)
    expect(Test.find(test.id).my_file.read).to eq 'this is stuff'
    test.destroy
  end
end
