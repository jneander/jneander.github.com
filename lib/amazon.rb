require 'aws-sdk'

module Amazon
  class S3
    def initialize(options)
      @options = options
      validate_options!
    end

    def deploy(changeset)
      Dir.chdir(@options[:source_path]) do
        changeset.updated.each do |file|
          write(file, File.read(file))
        end
        changeset.removed.each do |file|
          remove(file)
        end
      end
    end

    private

    def write(path, data)
      bucket.objects[path].write(data)
    end

    def remove(path)
      bucket.objects[path].delete
    end

    def validate_options!
      all_options_valid = @options[:access_key] &&
                          @options[:secret_key] &&
                          @options[:bucket_name]
      unless all_options_valid
        raise ArgumentError, ":access_key, :secret_key, and :bucket_name are required options"
      end
    end

    def s3
      @s3 ||= AWS::S3.new(access_key_id: @options[:access_key], secret_access_key: @options[:secret_key])
    end

    def bucket
      @bucket ||= s3.buckets[@options[:bucket_name]]
    end
  end
end
