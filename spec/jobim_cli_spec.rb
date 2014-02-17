require 'spec_helper'

describe Jobim::CLI, fakefs: true do

  let(:cli) { Jobim::CLI.new }

  describe '#parser' do
    describe '-a, --address' do
      it 'sets the host address' do
        cli.parse(%w[--address foo])
        expect(cli.options[:host]).to eql 'foo'
      end
    end

    describe '-d, --daemonize' do
      it 'sets the daemonize flag' do
        cli.parse(%w[--daemonize])
        expect(cli.options[:host]).to be_true
      end
    end

    describe '-p, --port' do
      it 'takes an Integer' do
        expect do
          cli.parse(%w[--port foo])
        end.to raise_error OptionParser::InvalidArgument
      end

      it 'considers 0 to be an invalid argument' do
        expect do
          cli.parse(%w[--port 0])
        end.to raise_error OptionParser::InvalidArgument
      end

      it 'sets the binding port' do
        cli.parse(%w[--port 3333])
        expect(cli.options[:port]).to eql 3333
      end
    end

    describe '-P, --prefix' do
      it 'sets the path to mount the app under' do
        cli.parse(%w[--prefix /foo])
        expect(cli.options[:prefix]).to eql '/foo'
      end
    end

    describe '-q, --quiet' do
      it 'sets the quiet flag' do
        cli.parse(%w[--quiet])
        expect(cli.options[:quiet]).to be_true
      end
    end

    describe '-h, --help' do
      it 'displays the help message' do
        expect($stdout).to receive(:write).with(cli.help)
        cli.parse(%w[--help])
      end
    end

    describe '--version' do
      it 'displays the version number' do
        expect($stdout).to receive(:write).with("#{Jobim::VERSION}\n")
        cli.parse(%w[--version])
      end
    end
  end

  describe '#parse', fakefs: true do
    it 'parses the cli option array' do
      args = %w[--port 3333 --prefix /foo]
      cli.parse(args)
      expect(args).to eql []
    end

    it 'sets the Directory option to its trailing argument' do
      args = %w[dir]
      cli.parse(args)
      expect(cli.options[:dir]).to eql '/dir'
    end
  end

  describe '#help' do
    it 'returns the help message' do
      expect(cli.help).to include('Usage: jobim [OPTION]... [DIRECTORY]')
    end
  end

end
