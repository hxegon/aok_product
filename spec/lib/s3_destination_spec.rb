require_relative '../../lib/s3_destination'
require 'json'

RSpec.describe S3Destination do
  context '#write' do
    let(:s3d) do
      # Make a dummy client object
      dummy_client = Object.new
      def dummy_client.upload_file(dummy_file_arg); true; end
      S3Destination.new(dummy_client)
    end

    it 'accumulates rows' do
      s3d.write(:row)
      expect(s3d.rows[0]).to eq :row
    end
  end

  context '#close' do
    let(:s3d) do
      # Make a dummy client object
      dummy_client = Object.new
      def dummy_client.upload_file(tmp_file_path)
        File.read(tmp_file_path)
      end

      S3Destination.new(dummy_client)
    end

    it 'calls #upload_file with a tmp file' do
      row = { test: :success }
      s3d.write(row)
      expect(s3d.close).to eq [row].to_json
    end
  end
end

RSpec.describe F2S3 do
  let(:f2s3)            { F2S3.new(bucket: 'bucket_name') }
  context 'pathing' do
    let(:bucket_folder)   { 'Folder/' }
    let(:bucket_filename) { 'filename.json' }
    let(:expected)        { bucket_folder + bucket_filename }

    context 'when path isn\'t inferable' do
      it 'assembles with explicit args' do
        actual = f2s3.bucket_path folder: bucket_folder, filename: bucket_filename

        expect(actual).to eq expected
      end
    end

    context 'when path is inferable' do
      let(:f2s3) do
        F2S3.new(bucket: 'bucket_name').tap do |f|
          f.bucket_folder   = bucket_folder 
          f.bucket_filename = bucket_filename
        end
      end

      it 'infers the path if none given' do
        actual = f2s3.bucket_path
        expect(actual).to eq expected
      end

      it 'uses an explicit when passed' do
        diff_filename = 'filename2.json'
        actual        = f2s3.bucket_path(folder: bucket_folder, filename: diff_filename)
        expect(actual).to eq (bucket_folder + diff_filename)
      end
    end

    context 'joining' do
      it 'joins correctly when folder doesn\'t include a trailing slash' do
        actual = f2s3.bucket_path folder: 'Folder', filename: 'filename.json'
        expect(actual).to eq 'Folder/filename.json'
      end

      it 'joins correctly when filename includes a preceding slash' do
        actual = f2s3.bucket_path folder: 'Folder/', filename: '/filename.json'
        expect(actual).to eq 'Folder/filename.json'
      end
    end
  end

end
