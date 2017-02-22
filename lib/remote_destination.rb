require 'json'

# Kiba wrapper for any client implementing :upload_string (see: F2S3)
class RemoteDestination
  attr_accessor :rows

  def initialize(client)
    unless client.respond_to?(:upload_string)
      raise ArgumentError, 'client needs to respond to :upload_string.'
    end

    @rows   = []
    @client = client
  end

  # Accumulates rows together
  # @see #close
  def write(row)
    rows << row
  end

  # Converts accumulated rows to json, passes it to @client.upload_string
  # @return Whatever @client.upload_string returns
  def close
    @client.upload_string(rows.to_json)
  end
end
