

require 'gocd/monitor/cli/base'
require 'optparse'

module Gocd
  module Monitor
    module CLI
      class LogLevelAnalyzeSupport
        def parse(opts)
          options = {}
          OptionParser.new do |opts|
            opts.banner = 'Usage: exe/gocd-monitor-log-analyze-support [OPTIONS]'

            options[:level] = 'ERROR'

            opts.on('-pDEST', '--path=DEST', 'Path to log file') do |dest|
              options[:path] = dest
            end

            opts.on('-lLEVEL', '--level=LEVEL', 'Log level to filter logs') do |level|
              options[:level] = level
            end

          end.parse!
          OpenStruct.new(options)
        end
      end
    end
  end
end