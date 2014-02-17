require 'spec_helper'

describe Jobim::Application, fakefs: true do

  describe '::run' do
    before(:each) do
      Jobim::Server.stub(:start!)
      $stdout.stub(:write)
      $stderr.stub(:write)
    end

    it 'exits on --help command flag' do
      expect { Jobim::Application.run('--help') }.to raise_error SystemExit
    end

    it 'exits on --version command flags' do
      expect { Jobim::Application.run('--version') }.to raise_error SystemExit
    end

    it 'starts the server' do
      expect(Jobim::Server).to receive(:start!)
      Jobim::Application.run
    end

    it 'catches InvalidOption and reports to stderr' do
      expect($stderr).to receive(:write)
      Jobim::Application.run('--foo')
    end

    it 'catches RuntimeError and reports to stderr' do
      expect($stderr).to receive(:write)
      Jobim::Server.unstub(:start!)
      Jobim::Application.run('--port', '1')
    end
  end

end
