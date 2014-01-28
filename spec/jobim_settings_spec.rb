require 'spec_helper'

describe Jobim::Settings, fakefs: true do

  describe "#initialize" do
  end

  describe "#options" do
    subject(:options) { Jobim::Settings.new.options }

    it 'defaults :Daemonize to false' do
      options[:Daemonize].should be_false
    end

    it 'defaults :Dir to current working directory' do
      options[:Dir].should eql Dir.pwd
    end

    it 'defaults :Host to localhost' do
      options[:Host].should eql 'localhost'
    end

    it 'defaults :Port to 3000' do
      options[:Port].should eql 3000
    end

    it 'default :Prefix to /' do
      options[:Prefix].should eql '/'
    end

    it 'defaults :Quiet to false' do
      options[:Quiet].should be_false
    end
  end

  describe "#load_file" do
  end

  describe "#load" do
  end

end
