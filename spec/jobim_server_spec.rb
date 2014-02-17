require 'spec_helper'

describe Jobim::Server, fakefs: true do

  before(:each) do
    Dir.mkdir("/web_app")
    Dir.mkdir("/web_app/trail_test")
    Dir.mkdir("/web_app/index_test")

    File.open("/web_app/index_test/index.html", "w") {|f| f.write(index) }
    File.open("/web_app/trail_test/foo.html", "w")   {|f| f.write(index) }
    File.open("/web_app/trail_test/foo", "w") {|f| f.write(index) }
  end

  let(:index)    { "<!DOCTYPE html>\n<html />\n" }
  let(:settings) { settings = Jobim::Settings.new }

  describe 'app', rack_test: true do
    before(:each) { $stdout.stub(:write) }

    let(:server) {
      settings.options[:dir] = '/web_app'
      Jobim::Server.new(settings.options)
    }

    let(:app) { server.app }

    it 'returns index.html from dirs when it exists' do
      get '/index_test/'
      expect(last_response).to be_ok
      expect(last_response.body).to eql index
    end

    it 'treats bare urls as directories when they are' do
      get '/trail_test'
      expect(last_response).to be_ok
      expect(last_response.body).to include "/trail_test/foo.html"
    end

    it 'treats bare urls as files when they are' do
      get '/trail_test/foo'
      expect(last_response).to be_ok
      expect(last_response.body).to eql index
    end
  end

  describe 'server' do
    let(:server) {
      settings.options[:daemonize] = true
      Jobim::Server.new(settings.options)
    }

    it 'sets server.pid_file if :daemonize is true' do
      expect(server.server.pid_file).to eql('jobim.pid')
    end

    it 'sets server.log_file if :daemonize is true' do
      expect(server.server.log_file).to eql('jobim.log')
    end
  end

end
