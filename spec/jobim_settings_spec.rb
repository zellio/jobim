require 'spec_helper'

describe Jobim::Settings, fakefs: true do

  before(:each) do
    unless example.metadata[:no_conf]
      Dir.mkdir('/home')
      Dir.mkdir('/home/jobim')
      Dir.mkdir('/home/jobim/public_html')
      Dir.mkdir('/home/jobim/projects')

      Dir.chdir('/home/jobim/projects')

      file = RealFile.expand_path(__FILE__)
      config_dir = RealFile.expand_path('../configs', file)

      r_cfg = RealFile.read(RealFile.expand_path('root_conf.yml', config_dir))
      u_cfg = RealFile.read(RealFile.expand_path('user_conf.yml', config_dir))
      l_cfg = RealFile.read(RealFile.expand_path('local_conf.yml', config_dir))
      e_cfg = RealFile.read(RealFile.expand_path('empty_conf.yml', config_dir))

      File.open('/.jobim.yml', 'w') { |f| f.write r_cfg }
      File.open('/home/.jobim.yml', 'w') { |f| f.write e_cfg }
      File.open('/home/jobim/.jobim.yaml', 'w') { |f| f.write u_cfg }
      File.open('/home/jobim/projects/.jobim.yaml', 'w') do |f|
        f.write l_cfg
      end
    end
  end

  let(:settings) { Jobim::Settings.new(false) }
  let(:options) { settings.options }

  describe '#initialize' do

  end

  describe '#options', no_conf: true do
    it 'defaults :daemonize to false' do
      expect(options[:daemonize]).to be_false
    end

    it 'defaults :dir to current working directory' do
      expect(options[:dir]).to eql Dir.pwd
    end

    it 'defaults :host to 0.0.0.0' do
      expect(options[:host]).to eql '0.0.0.0'
    end

    it 'defaults :port to 3000' do
      expect(options[:port]).to eql 3000
    end

    it 'defaults :prefix to /' do
      expect(options[:prefix]).to eql '/'
    end

    it 'defaults :quiet to false' do
      expect(options[:quiet]).to be_false
    end
  end

  describe '#load_file' do
    it 'loads config data into #options' do
      settings.load_file('/.jobim.yml')
      expect(options[:daemonize]).to be_true
    end

    it 'only changes configured options' do
      settings.load_file('/.jobim.yml')
      expect(options[:port]).to eql 3000
    end

    it 'expands directories relative to the config file location' do
      settings.load_file('/home/jobim/.jobim.yaml')
      expect(options[:dir]).to eql '/home/jobim/public_html'
    end

    it 'overrides only specified options' do
      settings.load_file('/home/jobim/.jobim.yaml')
      expect(options[:quiet]).to be_false
    end

    it 'handles empty configuration files' do
      expect { settings.load_file('/home/.jobim.yml') }.to_not raise_error
    end
  end

  describe '#load' do
    before(:each) { settings.load }

    it 'loads all config files from CWD to root' do
      expect(options[:daemonize]).to be_true
      expect(options[:port]).to eql 1234
      expect(options[:dir]).to eql '/home/jobim/public_html'
    end

    it 'overrides previous directory options with current ones' do
      expect(options[:dir]).to eql '/home/jobim/public_html'
    end

    it 'will check for yaml files only if there is no yml file' do
      expect(options[:prefix]).to eql '/jobim'
    end
  end

end
