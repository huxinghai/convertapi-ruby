require 'uri'

module ConvertApi
  class UploadIO
    def initialize(io, filename = nil)
      @io = io
      @filename = filename || io_filename || raise(FileNameError, 'IO filename must be provided')
    end

    def to_s
      file_id
    end

    def file_id
      result['FileId']
    end

    def file_name
      result['FileName']
    end

    def file_ext
      result['FileExt']
    end

    private

    def result
      @result ||= upload_file
    end

    def upload_file
      tmp = nil
      time = Benchmark.measure do
        tmp = ConvertApi.client.upload(@io, @filename)
      end
      warn("ConvertApi.upload_file 执行耗时: #{time.real.round(2)} 秒")
      tmp
    end

    def io_filename
      return unless @io.respond_to?(:path)
      File.basename(@io.path)
    end
  end
end
