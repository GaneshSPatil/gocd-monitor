require 'gocd/monitor/log_analyze_support'

module Gocd
  module Monitor
    class ThreadAnalyzeSupport < LogAnalyzeSupport
      attr_reader :options

      def initialize(options)
        @options = options
        super(options)
      end

      def perform(renderer=LogAnalyzeSupportRenderer.new)
        content = File.read(options[:path])
        filtered_logs = Array.new
        all_logs = content.split("\n")
        all_logs.each { |log|
          filtered_logs.push(prettify(log)) if is_of_user_choice?(log, options.id) }
        renderer.render(all_logs.size, filtered_logs)
      end
    end
  end
end