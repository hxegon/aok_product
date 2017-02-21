require_relative '../../lib/remote_destination'

RSpec.describe RemoteDestination do
  context '#write' do
    let(:s3d) do
      # Make a dummy client object
      dummy_client = Object.new
      def dummy_client.upload_string(dummy_file_arg); true; end
      RemoteDestination.new(dummy_client)
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
      def dummy_client.upload_string(tmp_file_path)
        File.read(tmp_file_path)
      end

      RemoteDestination.new(dummy_client)
    end

    it 'calls #upload_string with a tmp file' do
      row = { test: :success }
      s3d.write(row)
      expect(s3d.close).to eq [row].to_json
    end
  end
end
