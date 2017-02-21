require 'aws-sdk'
require_relative 'string_normalize'

# TODO: this should not be in this file
require 'dotenv'
Dotenv.load

# A module that wraps the AWS gem into a focused interface for uploading files
# to s3. Can infer the bucket path from either the last bucket path you used, or
# what you specify (either with bucket_path= or passed in with .new).
# @note You need some env variables with s3 tokens: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION
# @example Explicit usage pattern:
#   client = F2S3.new(bucket_name)
#   client.upload_string(data.to_json)
# @example Implicit usage pattern:
#   client = F2S3.new(bucket_name)
#   client.bucket_folder   = 'Staging'
#   client.bucket_filename = 'test.json'
#   client.upload_string(data.to_json)
class F2S3
  # def self.new_from_env
  attr_accessor :bucket_folder, :bucket_filename

  # @param env [Hash] ENV by default, see @required_keys.
  def initialize(bucket:, env: ENV)
    @s3     = Aws::S3::Resource.new
    @bucket = @s3.bucket(bucket)
    @env    = env

    @required_keys = %w[AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION].freeze
  end

  # @return Bool returns if string upload successful
  def upload_string(string, path = bucket_path)
    tmp = Tempfile.new('S3_Upload_Tempfile')
    tmp.write(string)
    tmp.close # close(ing) the file commits the write

    # will blow up tests if put in initialize
    missing_keys = @required_keys - @env.keys
    unless missing_keys.empty?
      fail ArgumentError, "#{missing_keys.join(', ')} #{missing_keys.size > 1 ? 'are' : 'is'} missing from environment variables."
    end

    # unlink tmpfile, but return result of upload_file
    @bucket.object(path).upload_file(tmp.path).tap { |_| tmp.unlink }
  end

  # assembles, normalizes, remembers a bucket path.
  def bucket_path(folder: bucket_folder, filename: bucket_filename)
    bucket_folder   = normalize_folder(folder)
    bucket_filename = normalize_filename(filename)

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
