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

  let(:settings) do
    cli = Jobim::CLI.new
    cli.parse(%w[--no-config])

    settings = cli.settings
    settings.conf_dir = Dir.pwd
    settings
  end

  describe '#initialize' do

  end

  describe '#load_file' do
    it 'loads config data into settings' do
      settings.load_file('/.jobim.yml')
      expect(settings.daemonize).to be_true
    end

    it 'only changes configured options' do
      settings.load_file('/.jobim.yml')
      expect(settings.port).to eql 3000
    end

    it 'expands directories relative to the config file location' do
      settings.load_file('/home/jobim/.jobim.yaml')
      expect(settings.dir).to eql '/home/jobim/public_html'
    end

    it 'overrides only specified options' do
      settings.load_file('/home/jobim/.jobim.yaml')
      expect(settings.quiet).to be_false
    end

    it 'handles empty configuration files' do
      expect { settings.load_file('/home/.jobim.yml') }.to_not raise_error
    end
  end

  describe '#load' do
    before(:each) { settings.load }

    it 'loads all config files from CWD to root by default' do
      expect(settings.daemonize).to be_true
      expect(settings.port).to eql 1234
      expect(settings.dir).to eql '/home/jobim/public_html'
    end

    it 'overrides previous directory options with current ones' do
      expect(settings.dir).to eql '/home/jobim/public_html'
    end

    it 'will check for yaml files only if there is no yml file' do
      expect(settings.prefix).to eql '/jobim'
    end

    it 'can handle absolute directories' do
      expect(settings.daemonize).to be_true
      expect(settings.port).to eql 1234
      expect(settings.dir).to eql '/home/jobim/public_html'
    end

    it 'can handle relative directories' do
      settings.load('../')
      expect(settings.prefix).to eql '/web_root'
      expect(settings.port).to eql 1234
    end
  end

end
