require_relative '../../lib/s3'

RSpec.describe S3 do
  context '.missing_keys' do
    it 'to not be empty when there are no keys in env' do
      expect(S3.missing_keys(Hash.new)).to_not be_empty
    end
  end
end

RSpec.describe S3::Path do
  it 'joins correctly when folder doesn\'t include a trailing slash' do
    path = S3::Path.new 'Folder', 'filename.json'
    expect(path.to_s).to eq 'Folder/filename.json'
  end

  it 'joins correctly when filename includes a preceding slash' do
    path = S3::Path.new 'Folder/', '/filename.json'
    expect(path.to_s).to eq 'Folder/filename.json'
  end
end
