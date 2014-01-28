require 'spec_helper'

describe Jobim::Settings, fakefs: true do

  before(:each) do
    puts "foo"
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
  end

  describe "#load" do
  end

end
