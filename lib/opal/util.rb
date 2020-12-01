# frozen_string_literal: true

require 'open3'

module Opal
  module Util
    extend self

    HIDE_STDERR = /mswin|mingw/ =~ RUBY_PLATFORM ? '2> nul' : '2> /dev/null'

    ExitStatusError = Class.new(StandardError)

    # Used for uglifying source to minify.
    #
    #     Opal::Util.uglify("javascript contents")
    #
    # @param str [String] string to minify
    # @return [String]
    def uglify(source)
      out, _, status = Open3.capture3("bin/yarn -s run uglifyjs -c #{HIDE_STDERR}", stdin_data: source)
      raise ExitStatusError, "exited with status #{status.exitstatus}" unless status.success?
      out
    end

    # Gzip code to check file size.
    def gzip(source)
      out, _, status = Open3.capture3("gzip -f #{HIDE_STDERR}", stdin_data: source)
      raise ExitStatusError, "exited with status #{status.exitstatus}" unless status.success?
      out
    end
  end
end
