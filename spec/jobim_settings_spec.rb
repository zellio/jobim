require 'spec_helper'

describe Jobim::Settings do

  attr_reader :options

  describe "#initialize" do
  end

  describe "#options", fakefs: true do
    subject(:options) { Jobim::Settings.new.options }

    it 'defaults :Daemonize to false' do
      options[:Daemonize].should be_false
    end

    it 'defaults :Dir to current working directory' do
      options[:Dir].should be Dir.pwd
    end

    it 'defaults :Host to localhost' do
      options[:Host].should be 'localhost'
    end

    it 'defaults :Port to 3000' do
      options[:Port].should be 3000
    end

    it 'default :Prefix to /' do
      options[:Prefix].should be '/'
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
