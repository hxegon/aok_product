require 'json'

# Kiba wrapper for any client implementing :upload_string (see: F2S3)
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
    # TODO: change output to something more user friendly than a upload success bool
    @client.upload_string(rows.to_json)
  end
end
