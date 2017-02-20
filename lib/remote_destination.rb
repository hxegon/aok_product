require 'json'

# Kiba wrapper for any client implementing :upload_file (see: F2S3)
class RemoteDestination
  attr_accessor :rows

  def initialize(client)
    unless client.respond_to?(:upload_file)
      raise ArgumentError, "client needs to respond to :upload_file."
    end

    @rows   = []
    @client = client
  end

  # Accumulates rows together
  # @see #close
  def write(row)
    rows << row
  end

  # Converts accumulated rows to json, turns into a tmp file, passes it to
  # @client.upload_file
  # @return Whatever @client.upload_file returns
  def close
    # convert rows to json
    tmp = Tempfile.new('S3Destination')
    tmp.write(rows.to_json)
    tmp.close # close(ing) the file commits the write

    # The assumptions about #upload_file using a file path is jank AF
    #                            # unlink, but return upload_file result
    @client.upload_file(tmp.path).tap { |_| tmp.unlink }
  end
end
