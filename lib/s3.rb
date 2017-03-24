require 'aws-sdk'
require_relative 'string_substitute'

module S3
  REQUIRED_ENV_KEYS = %w(AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION).freeze

  # Checks for the environment variables required by Client
  def self.missing_keys(env = ENV)
    REQUIRED_ENV_KEYS - env.keys
  end

  def self.missing_keys?(env = ENV)
    !missing_keys(env).empty?
  end

  # Takes care of wierd s3 specific path formatting rules
  Path = Struct.new(:folder, :filename) do
    using StringSubstitute

    # merges the folder, filename together, honoring some s3 formatting rules.
    def bucket_path
      formatted_filename = filename.substitute(/^\//, '')
      formatted_folder   = folder.match?(/\/$/) ? folder : (folder + '/')

      # This line is deceptive. Pathname.new(foo).to_s makes some formatting
      # changes.
      (Pathname.new(formatted_folder) + Pathname(formatted_filename)).to_s
    end

    # alias for #bucket_path
    def to_s
      bucket_path
    end
  end

  # Wrapper client for S3 string data upload.
  class Client
    # @param bucket [String] What bucket name you want to upload to.
    # @param path [String] (anything #to_s able) #...
    def initialize(bucket:, path:)
      raise "#{missing_keys.join(', ')} missing from environment variables." if missing_keys?

      @s3     = Aws::S3::Resource.new
      @bucket = @s3.bucket(bucket)
      @path   = path
    end

    # @return Bool returns if string upload successful
    def upload_string(string, path = @path)
      Tempfile.create('S3_Upload_Tempfile') do |f|
        f.write(string)
        f.close
        @bucket.object(path.to_s).upload_file(tmp.path)
      end
    end
  end
end
