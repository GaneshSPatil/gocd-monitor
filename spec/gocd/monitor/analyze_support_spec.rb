require 'spec_helper'
require 'json'

RSpec.describe Gocd::Monitor::AnalyzeSupport do
  it 'should find long running threads between two snapshots' do
    log_dir = '../../../fixtures/api-support'
    analyze = Gocd::Monitor::AnalyzeSupport.new(OpenStruct.new(dest_dir: File.expand_path(log_dir, __FILE__)))

    renderer = double('renderer')

    options = {
      api_support_hash: JSON.parse(File.read('spec/fixtures/api-support/2016-06-13_12:13:41+0530')),
      api_support_hash_next: JSON.parse(File.read('spec/fixtures/api-support/2016-06-13_12:13:45+0530')),
      thread_id: '951'
    }

    expect(renderer).to receive(:identical_threads).with(options)
    expect(renderer).to receive(:render).with('Found a potential long running thread between snapshots at 2016-06-13T12:13:41+05:30 and 2016-06-13T12:13:45+05:30')
    expect(renderer).to receive(:render).with('Thread ID: 951')
    details ={
      'Id': 951,
      'Stack Trace': [
        'sun.misc.Unsafe.park(Native Method)',
        'java.util.concurrent.locks.LockSupport.parkNanos(LockSupport.java:226)',
        'java.lang.Thread.run(Thread.java:745)'
      ]
    }

    expect(renderer).to receive(:render).with("Thread details:\n#{JSON.pretty_generate(details).each_line.collect { |l| "    #{l}" }.join}")

    analyze.perform(renderer)
  end
end

