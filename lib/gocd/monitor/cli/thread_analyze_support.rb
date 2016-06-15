

require 'gocd/monitor/cli/base'
require 'optparse'

module Gocd
  module Monitor
    module CLI
      class ThreadAnalyzeSupport
        def parse(opts)
          options = {}
          OptionParser.new do |opts|
            opts.banner = 'Usage: exe/thread-analyze-support [OPTIONS]'

            opts.on('-pDEST', '--path=DEST', 'Path to log file') do |dest|
              options[:path] = dest
            end

            opts.on('-iID', '--id=ID', 'Thread ID') do |id|
              options[:id] = id
            end

          end.parse!
          OpenStruct.new(options)
        end
      end
    end
  end
end