require 'gocd/monitor/cli/base'
require 'optparse'

module Gocd
  module Monitor
    module CLI
      class AnalyzeSupport
        def parse(opts)
          default_options = {
            dest_dir: Dir.pwd,
          }
          options = {}
          OptionParser.new do |opts|
            opts.banner = 'Usage: exe/gocd-monitor-analyze-support [OPTIONS]'

            opts.on('-dDEST', '--destination=DEST', 'Destination directory where logs are stored, defaults to current working directory') do |dest|
              options[:dest_dir] = dest
            end
          end.parse!

          options = default_options.merge(options)
          OpenStruct.new(options)
        end
      end
    end
  end
end