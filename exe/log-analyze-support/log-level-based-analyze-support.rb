#!/usr/bin/env ruby

require 'bundler/setup'

require 'gocd/monitor'
require 'gocd/monitor/cli/log_level_analyze_support'

options = Gocd::Monitor::CLI::LogLevelAnalyzeSupport.new.parse(ARGV)
Gocd::Monitor::LogLevelAnalyzeSupport.new(options).perform