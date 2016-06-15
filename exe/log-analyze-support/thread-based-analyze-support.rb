#!/usr/bin/env ruby

require 'bundler/setup'

require 'gocd/monitor'
require 'gocd/monitor/cli/thread_analyze_support'

options = Gocd::Monitor::CLI::ThreadAnalyzeSupport.new.parse(ARGV)
Gocd::Monitor::ThreadAnalyzeSupport.new(options).perform