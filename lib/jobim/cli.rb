
require 'optparse'

class Jobim::CLI

  attr_reader :parser, :options

  def self.run!(*args, &opts)
    cli = Jobim::CLI.new
    begin
      cli.parse(args)
      cli.options
    rescue
      puts cli.help
      exit
    end
  end

  def options
    @options ||= {
      :Daemonize => false,
      :Dir => Dir.pwd,
      :Host => '0.0.0.0',
      :Port => 5634,
      :Quiet => false
    }
  end

  def parser
    @parser ||= OptionParser.new do |o|
      o.banner = "jobim - TODO: FINISH ME"
      o.separator ""
      o.separator "Usage: jobim [OPTION]... [DIRECTORY]"

      o.separator ""
      o.separator "Specific options:"

      o.on("-a", "--address HOST",
           "bind to HOST address (default: 0.0.0.0)") do |host|
        options[:Host] = host
      end

      o.on "-d", "--daemonize", "Run as a daemon process" do
        options[:Daemonize] = true
      end

      o.on "-p", "--port PORT", "use PORT (default: 5634)" do |port|
        options[:Port] = port
      end

      o.on "-q", "--quiet", "Silence all logging" do
        options[:Quiet] = true
      end

      o.separator ""
      o.separator "General options:"

      o.on "-h", "--help", "Display this help message." do
        puts help
        exit
      end
      o.on "--version", "Display the version number" do
        options[:version] = Jobim::VERSION
        puts options[:version]
        exit
      end
    end
  end

  def parse(args)
    parser.parse!(args)
    options[:Dir] = File.expand_path(args[0]) if args.length == 1
  end

  def help
    parser.to_s
  end

end
