require 'spec_helper'

RSpec.describe Gocd::Monitor::ThreadAnalyzeSupport do
  it 'should find the logs for the specified thread ID' do
    path = '../../../fixtures/go-server.log'
    id = 'qtp1033212949-3754873'
    analyze = Gocd::Monitor::ThreadAnalyzeSupport.new(OpenStruct.new(path: File.expand_path(path, __FILE__), id: id))
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
      },
      {date: '2016-05-18',
       time: '09:00:18,894',
       log_level: 'FATAL',
       class: 'BuildRepositoryRemoteImpl:106',
       thread: '[qtp1033212949-3754873]',
       message: 'bomb'
      }
    ]
    count = 6 #total logs in log file
    expect(renderer).to receive(:render).with(count, options)
    analyze.perform(renderer)
  end
end
