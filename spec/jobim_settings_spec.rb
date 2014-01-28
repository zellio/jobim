require 'spec_helper'

describe Jobim::Settings, fakefs: true do

  before(:each) do
    Dir.mkdir("/jobim")
    Dir.mkdir("/jobim/pub")
  end

  describe "#initialize" do
  end

  describe "#options" do
    subject(:options) { Jobim::Settings.new.options }

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
    before(:each) do
      file = RealFile.expand_path(__FILE__)
      config_dir = RealFile.expand_path("../configs", file)
      root_config = RealFile.read(RealFile.expand_path("root_conf.yml", config_dir))
      user_config = RealFile.read(RealFile.expand_path("user_conf.yml", config_dir))

      File.open("/.jobim.yml", "w") {|file| file.write root_config }
      File.open("/jobim/.jobim.yml", "w") {|file| file.write user_config }
    end

    it 'loads config data into #options' do
    end

    it 'expands directories relative to the config file location' do
    end
  end

  describe "#load" do
  end

end
