require_relative '../../lib/f2s3'

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
