require 'spec_helper'

RSpec.describe Gocd::Monitor::LogLevelAnalyzeSupport do
  it 'should find the logs for the specified log level' do
    path = '../../../fixtures/go-server.log'
    level = 'WARN'
    analyze = Gocd::Monitor::LogLevelAnalyzeSupport.new(OpenStruct.new(path: File.expand_path(path, __FILE__), level: level))
    renderer = double('renderer')
    options =[
      {date: '2016-06-14',
       time: '10:52:19,334',
       log_level: 'WARN',
       class: 'GoSslSocketConnector:82',
       thread: '[qtp1033212949-3754873]',
       message: 'Renegotiation Allowed: true'
      },
      {date: '2016-06-14',
       time: '10:52:20,354',
       log_level: 'WARN',
       class: 'GoSslSocketConnector:82',
       thread: '[qtp1033212949-3754873]',
       message: 'Renegotiation Allowed: false'
      }
    ]
    count = 6 #total logs in log file
    expect(renderer).to receive(:render).with(count, options)
    analyze.perform(renderer)
  end
end
