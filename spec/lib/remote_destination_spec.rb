require_relative '../../lib/remote_destination'

RSpec.describe RemoteDestination do
  context '#write' do
    let(:s3d) do
      # Make a dummy client object
      dummy_client = Object.new
      def dummy_client.upload_string(dummy_string_data); true; end
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
      def dummy_client.upload_string(dummy_string_data)
        dummy_string_data
      end

      RemoteDestination.new(dummy_client)
    end
  end
end
