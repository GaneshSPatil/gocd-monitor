require 'gocd/monitor/cli/base'
require 'optparse'
require 'logger'
require 'ostruct'

module Gocd
  module Monitor
    module CLI
      class ApiSupport < Base
        def parse(opts)
          default_options = {
            interval: 10,
            dest_dir: Dir.pwd,
            log_file: STDERR,
            log_level: Logger::INFO
          }
          options = {}
          OptionParser.new do |opts|
            opts.banner = 'Usage: exe/gocd-monitor-api-support [OPTIONS]'

            opts.on('-sURL', '--server-url=URL', 'GoCD Server URL (https://example.com:8154/go)') do |url|
              options[:go_base_url] = url
            end

            opts.on('-uUSERNAME', '--username=USERNAME', 'GoCD Username') do |username|
              options[:username] = username
            end

            opts.on('-pPASSWORD', '--password=PASSWORD', 'GoCD User\'s password') do |password|
              options[:password] = password
            end

            opts.on('-iINTERVAL', '--interval=INTERVAL', 'Time interval in seconds to run monitor activity') do |t|
              options[:interval] = t
            end

            opts.on('-dDEST', '--destination=DEST', 'Destination directory to store logs, defaults to current working directory') do |dest|
              options[:dest_dir] = dest
            end

            opts.on('-LLOG_FILE', '--log-file=LOG_FILE', 'The log file, defaults to STDERR') do |logfile|
              options[:log_file] = logfile
            end

            opts.on('-lLEVEL', '--log-level=LEVEL', "The log level. Valid values are #{Logger::Severity.constants}") do |level|
              options[:log_level] = Logger::Severity.const_get(level.to_sym)
            end
          end.parse!

          options = default_options.merge(options)

          options[:logger] = Logger.new(options.delete(:log_file))
          options[:logger].level = options.delete(:log_level)

          OpenStruct.new(options)
        end
      end
    end
  end
end

