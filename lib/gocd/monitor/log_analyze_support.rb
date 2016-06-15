module Gocd
  module Monitor
    class LogAnalyzeSupport
      attr_reader :options
      def initialize(options)
        @options = options
      end

      private
      def is_of_user_choice?(log, user_option)
        log.include?(user_option)
      end

      def prettify(log)
        info, message = log.split(/ - /)
        info = info.split(/\s+/)
        {date: info.shift, time: info.shift, log_level: info.shift, class: info.pop, thread: info.join(' '), message: message}
      end

      class LogAnalyzeSupportRenderer
        def render(total_count, filtered_log)
          p total_count
          p filtered_log
          puts "Logs Processed: #{total_count}"
          puts "Filtered Log Count: #{filtered_log.size}"
          puts "Filtered Logs:#{JSON.pretty_generate(filtered_log).each_line.collect { |l| "    #{l}" }.join}"
        end
      end

    end
  end
end