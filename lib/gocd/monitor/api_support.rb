require 'logger'
require 'faraday'
require 'uri'
require 'facter'
require 'json'
require 'rake/file_utils_ext'

require 'gocd/monitor/cli/api_support'

module Gocd
  module Monitor
    class ApiSupport
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def perform
        options.logger.debug("User arguments — #{options}")
        begin_time = Time.now
        FileUtils.mkdir_p(api_support_dir_name)
        conn = create_persistent_connection
        gather_os_facts
        while true
          begin
            options.logger.debug('Making Request To Get GoCD Server Information')
            server_info = get_server_info(conn)
            log_info_to_file(server_info)
          rescue => e
            options.logger.error(e)
            if begin_time + 10 >= Time.now
              abort(e.message)
            end
          end
          sleep(options.interval.to_i)
        end
      end

      private
      def get_server_info(connection)
        response = connection.get
        if response.status == 200
          response.body
        else
          raise "The server sent an unexpected status code — #{response.status}"
        end
      end

      def gather_os_facts
        options.logger.info 'Gathering facts about this machine'
        File.open(File.join(options.dest_dir, "os-facts.json"), 'w') { |f|
          f.puts JSON.pretty_generate(Facter.to_hash)
        }
      end

      def create_persistent_connection
        conn = Faraday.new(url: options.go_base_url) do |faraday|
          faraday.adapter :net_http_persistent
        end
        conn.basic_auth(options.username, options.password)
        conn
      end

      def log_info_to_file(server_info)
        time = Time.now.strftime('%Y-%m-%d_%H:%M:%S%z')
        filename = File.join(api_support_dir_name, time)
        options.logger.debug("Writing log to file - #{filename}")
        File.open(filename, 'w') { |f| f.write(server_info) }
      end

      def api_support_dir_name
        File.join(options.dest_dir, 'api-support')
      end
    end
  end
end
