require 'aws-sdk'
require 'json'

# TODO: this should not be in this file
require 'dotenv'
Dotenv.load

# A module that wraps the AWS gem into a focused interface for uploading files
# to s3. Can infer the bucket path from either the last bucket path you used, or
# what you specify (either with bucket_path= or passed in with .new).
# @note You need some env variables with s3 tokens: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION
# @example Explicit usage pattern:
#   bucket_name     = 'bucketname'
#   bucket_path     = 'Staging/test.json'
#   local_file_path = 'test.json'
#   F2S3.upload_file(local_file_path, bucket_path, bucket_name)
# @example Implicit usage pattern:
#   bucket_name = 'bucketname'
#   bucket_path = 'Staging'
#   client = F2S3.new(bucket_name, bucket_path) # you can also set bucket_path with #bucket_path=
#   client.upload_file('test.json')
class F2S3
  # def self.new_from_env

  def initialize(bucket:, path:nil)
    @s3               = Aws::S3::Resource.new
    @bucket           = @s3.bucket(bucket)
    @last_bucket_path = path
    @required_keys = %w[AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION].freeze
  end

  # def self.upload_file(bucket_name # For a simpler interface

  # UNSAFE. UNTESTED. UNTITLED. UNMASTERED.
  # @return Bool returns true if file upload successful, false if not
  def upload_file(local_file_path, bucket_path=nil)
    @bucket.object(make_bucket_path(bucket_path, local_file_path))
      .upload_file(local_file_path) # TODO: Am I 100% sure this is a file path and not an IO object?
  end

  # set the bucket path used to infer bucket paths
  def bucket_path=(bucket_path)
    @last_bucket_path = bucket_path
  end

  # Handles the bucket_path inference plumbing
  def make_bucket_path(bucket_path, local_file_path)
    @last_bucket_path = bucket_path || infer_bucket_path(local_file_path)
  end

  private

  # Tries to infer the bucket_path from the last used bucket path
  def infer_bucket_path(file_target)
    if @last_bucket_path.nil?
      raise RuntimeError, "No @last_bucket_path to infer bucket path from. Try specifying manually."
    end

    Pathname.dirname(@last_bucket_path) + Pathname.basename(file_target)
  end
end

# Kiba wrapper for any client implementing :upload_file (see: F2S3)
class S3Destination
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
    tmp = Tempfile.new('S3Destination_tmpfile')
    tmp.write(rows.to_json)
    tmp.close # close(ing) the file commits the write

    #                            # unlink, but return upload_file result
    @client.upload_file(tmp.path).tap { |_| tmp.unlink }
  end
end
