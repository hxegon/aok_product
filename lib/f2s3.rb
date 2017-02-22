require 'aws-sdk'
require_relative 'string_substitute'

# TODO: update documentation
# TODO: rename file

module S3
  module Config 
    REQUIRED_ENV_KEYS = %w[AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION].freeze

    def self.missing_keys(env = ENV)
      REQUIRED_ENV_KEYS - env.keys
    end

    def self.missing_keys?
      !missing_keys.empty?
    end
  end

  Path = Struct.new(:folder, :filename) do
    using StringSubstitute

    def bucket_path
      formatted_filename = filename.substitute(/^\//, '')
      formatted_folder   = folder.match?(/\/$/) ? folder : (folder + '/')

      (Pathname.new(formatted_folder) + Pathname(formatted_filename)).to_s
    end

    def to_s
      bucket_path
    end
  end

  # Wrapper client for S3 string data upload.
  class Client
    # @param bucket [String] What bucket name you want to upload to.
    # @param path [String] (anything #to_s able) #...
    def initialize(bucket:, path:)
      raise "#{missing_keys.join(', ')} missing from environment variables." if S3::Config.missing_keys?

      @s3     = Aws::S3::Resource.new
      @bucket = @s3.bucket(bucket)
      @path   = path
    end

    # @return Bool returns if string upload successful
    def upload_string(string, path = @path)
      tmp = Tempfile.new('S3_Upload_Tempfile')
      tmp.write(string)
      tmp.close # close(ing) the file commits the write

      # unlink tmpfile, but return result of upload_file
      @bucket.object(path.to_s).upload_file(tmp.path).tap { |_| tmp.unlink }
    end
  end
end
