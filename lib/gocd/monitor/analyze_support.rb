require 'json'

module Gocd
  module Monitor
    class AnalyzeSupport
      attr_reader :options
      def initialize(options)
        @options = options
      end

      def perform(renderer=AnalyzeSupportRenderer.new)
        log_files = get_log_files

        log_files.each_cons(2).each do |a, b|
          api_support_hash = get_hash(a)
          api_support_hash_next = get_hash(b)

          blocked_threads = get_blocked_threads(api_support_hash)
          blocked_threads_next = get_blocked_threads(api_support_hash_next)

          api_support_timestamp = api_support_hash['Timestamp']
          api_support_timestamp_next = api_support_hash_next['Timestamp']

          blocked_threads.each do |thread_id, details|
            same_thread_in_next_snapshot = blocked_threads_next[thread_id]

            next if %w(TIMED_WAITING WAITING).include?(details['State'])
            next unless same_thread_in_next_snapshot

            if details['Stack Trace'] == same_thread_in_next_snapshot['Stack Trace']
              p :identical
              renderer.identical_threads({
                                           api_support_hash: api_support_hash,
                                           api_support_hash_next: api_support_hash_next,
                                           thread_id: thread_id
                                         })
              renderer.render "Found a potential long running thread between snapshots at #{api_support_timestamp} and #{api_support_timestamp_next}"
              renderer.render "Thread ID: #{thread_id}"
              renderer.render "Thread details:\n#{JSON.pretty_generate(details).each_line.collect { |l| "    #{l}" }.join}"
            end
          end
        end
      end

      class AnalyzeSupportRenderer
        def identical_threads(options)
          @api_support_hash = options[:api_support_hash]
          @api_support_hash_next = options[:api_support_hash_next]
          @thread_id = options[:thread_id]
        end

        def render(data)
          puts data
        end
      end

      private
      def get_blocked_threads(hash)
        hash['Thread Information']['Stack Trace']
      end

      def get_hash(file_name)
        JSON.parse(File.read(file_name))
      end

      def get_log_files
        Dir[File.join(options.dest_dir, '*')].sort
      end
    end
  end
end