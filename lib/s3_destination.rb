require 'aws-sdk'
require 'dotenv'

Dotenv.load

# (expicit/implicit) TODO: The way this class is written doesn't make the difference between:
# a) A bucket path to tack filenames onto and use as the remote file path
# and
# b) A *full*, *explicit* bucket path to be used as a target path, as is.

# (examples) TODO: Provide Example docs with and w/o bucket_name inference.
#   Should be enough to mitigate the (explicit/implicit) TODO

# BOOKMARK TODO: figure out what env vars need to be present. Document them.
# should be in a dotenv in a project using s3
# The .env file, with the auth and required stuff, is on my laptop 8()

# Wraps the AWS gem S3 interface. Can infer the bucket path from either the last
# bucket path you used, or what you specify (either with bucket_path= or passed in with .new)
class F2S3
  # def self.new_from_env

  def initialize(bucket_name, bucket_path=nil)
    @s3               = Aws::S3::Resource.new
    @bucket           = @s3.bucket(bucket_name)
    @last_bucket_path = bucket_path
  end

  # def self.upload_file(bucket_name # For a simpler interface

  # UNSAFE. UNTESTED. 
  def upload_file(local_file_path, bucket_path=nil)
    @bucket.object(make_bucket_path(bucket_path, local_file_path))
      .upload_file(local_file_path)
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
