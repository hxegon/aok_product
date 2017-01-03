require 'aws-sdk'
require 'json'

# TODO: this should not be in this file
require 'dotenv'
Dotenv.load

# CLEAN MP, doesn't override core method.
class String
  # Clean string of regex, return string. Returns string even if regex doesn't match
  def normalize(pattern, replacement)
    (val = gsub(pattern, replacement)) == true ? self : val
  end
end

# A module that wraps the AWS gem into a focused interface for uploading files
# to s3. Can infer the bucket path from either the last bucket path you used, or
# what you specify (either with bucket_path= or passed in with .new).
# @note You need some env variables with s3 tokens: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION
# @example Explicit usage pattern:
#   client = F2S3.new(bucket_name)
#   client.upload_file('/tmp/farquad.json', 'Staging/test.json')
# @example Implicit usage pattern:
#   client = F2S3.new(bucket_name)
#   client.bucket_folder   = 'Staging'
#   client.bucket_filename = 'test.json'
#   client.upload_file('/tmp/farquad.json')
class F2S3
  # def self.new_from_env
  attr_accessor :target_filename, :bucket_folder, :bucket_filename
  
  # @param env [Hash] ENV by default, see @required_keys.
  def initialize(bucket:, env:ENV)
    @s3     = Aws::S3::Resource.new
    @bucket = @s3.bucket(bucket)
    @env    = env

    @required_keys = %w[AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION].freeze
  end

  # UNSAFE. UNTESTED. UNTITLED. UNMASTERED.
  # @return Bool returns true if file upload successful, false if not
  def upload_file(local_file_path, bucket_path=nil)

    # will blow up tests if put in initialize
    unless (required_keys - @env.keys).empty?
      raise ArgumentError, "env must contain #{required_keys.join(', ')}"
    end

    @bucket.object(make_bucket_path(bucket_path, local_file_path))
      .upload_file(local_file_path) # TODO: Am I 100% sure this is a file path and not an IO object?
  end

  # assembles, normalizes, remembers a bucket path.
  def bucket_path(folder:nil, filename:nil)
    folder    ||= bucket_folder
    filename  ||= bucket_filename

    folder      = normalize_folder(folder)
    filename    = normalize_filename(filename)

    (Pathname.new(bucket_folder) + Pathname(bucket_filename)).to_s
  end

  private

  def normalize_folder(folder)
    @bucket_folder = folder.match?(/\/$/) ? folder : (folder + '/')
  end

  def normalize_filename(filename)
    @bucket_filename = filename.normalize(/^\//, '')
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
    tmp = Tempfile.new('S3Destination')
    tmp.write(rows.to_json)
    tmp.close # close(ing) the file commits the write

    #                            # unlink, but return upload_file result
    @client.upload_file(tmp.path).tap { |_| tmp.unlink }
  end
end
