require 'spec_helper'

describe Jobim::Settings, fakefs: true do

  before(:each) do
    unless example.metadata[:no_conf]
      Dir.mkdir("/home")
      Dir.mkdir("/home/jobim")
      Dir.mkdir("/home/jobim/public_html")
      Dir.mkdir("/home/jobim/projects");

      Dir.chdir("/home/jobim/projects");

      file = RealFile.expand_path(__FILE__)
      config_dir = RealFile.expand_path("../configs", file)

      r_cfg = RealFile.read(RealFile.expand_path("root_conf.yml", config_dir))
      u_cfg = RealFile.read(RealFile.expand_path("user_conf.yml", config_dir))
      l_cfg = RealFile.read(RealFile.expand_path("local_conf.yml", config_dir))

      File.open("/.jobim.yml", "w") {|file| file.write r_cfg }
      File.open("/home/jobim/.jobim.yaml", "w") {|file| file.write u_cfg }
      File.open("/home/jobim/projects/.jobim.yaml", "w") do |file|
        file.write l_cfg
      end
    end
  end

  let(:settings) { Jobim::Settings.new(false) }
  let(:options) { settings.options }

  describe "#initialize" do

  end

  describe "#options", no_conf: true do
    it 'defaults :Daemonize to false' do
      expect(options[:Daemonize]).to be_false
    end

    it 'defaults :Dir to current working directory' do
      expect(options[:Dir]).to eql Dir.pwd
    end

    it 'defaults :Host to 0.0.0.0' do
      expect(options[:Host]).to eql '0.0.0.0'
    end

    it 'defaults :Port to 3000' do
      expect(options[:Port]).to eql 3000
    end

    it 'defaults :Prefix to /' do
      expect(options[:Prefix]).to eql '/'
    end

    it 'defaults :Quiet to false' do
      expect(options[:Quiet]).to be_false
    end
  end

  describe "#load_file" do
    it 'loads config data into #options' do
      settings.load_file("/.jobim.yml")
      expect(options[:Daemonize]).to be_true
    end

    it 'only changes configured options' do
      settings.load_file('/.jobim.yml')
      expect(options[:Port]).to eql 3000
    end

    it 'expands directories relative to the config file location' do
      settings.load_file('/home/jobim/.jobim.yaml')
      expect(options[:Dir]).to eql "/home/jobim/public_html"
    end

    it 'overrides only specified options' do
      settings.load_file('/home/jobim/.jobim.yaml')
      expect(options[:Quiet]).to be_false
    end
  end

  describe "#load" do
    before(:each) { settings.load }

    it 'loads all config files from CWD to root' do
      expect(options[:Daemonize]).to be_true
      expect(options[:Port]).to eql 1234
      expect(options[:Dir]).to eql '/home/jobim/public_html'
    end

    it 'overrides previous directory options with current ones' do
      expect(options[:Dir]).to eql '/home/jobim/public_html'
    end

    it 'will check for yaml files only if there is no yml file' do
      expect(options[:Prefix]).to eql '/jobim'
    end
  end

end
