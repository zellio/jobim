require 'spec_helper'

describe Jobim::Settings, fakefs: true do

  let(:settings) { Jobim::Settings.new }
  let(:options) { settings.options }

  before(:each) do
    Dir.mkdir("/jobim")
    Dir.mkdir("/jobim/pub")

    unless example.metadata[:no_configs]
      file = RealFile.expand_path(__FILE__)
      config_dir = RealFile.expand_path("../configs", file)
      root_config = RealFile.read(RealFile.expand_path("root_conf.yml", config_dir))
      user_config = RealFile.read(RealFile.expand_path("user_conf.yml", config_dir))

      File.open("/.jobim.yml", "w") {|file| file.write root_config }
      File.open("/jobim/.jobim.yml", "w") {|file| file.write user_config }
    end
  end

  describe "#initialize" do
  end

  describe "#options", no_configs: true do
    it 'defaults :Daemonize to false' do
      expect(options[:Daemonize]).to be_false
    end

    it 'defaults :Dir to current working directory' do
      expect(options[:Dir]).to eql Dir.pwd
    end

    it 'defaults :Host to localhost' do
      expect(options[:Host]).to eql 'localhost'
    end

    it 'defaults :Port to 3000' do
      expect(options[:Port]).to eql 3000
    end

    it 'default :Prefix to /' do
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

    it 'only changes confiugred options' do
      settings.load_file('/.jobim.yml')
      expect(options[:Port]).to eql 3000
    end

    it 'expands directories relative to the config file location' do
      settings.load_file('/jobim/.jobim.yml')
      expect(options[:Dir]).to eql "/jobim/pub"
    end
  end

  describe "#load" do
  end

end
