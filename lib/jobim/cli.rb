require 'optparse'

class Jobim::CLI

  attr_reader :parser, :options

  def self.run!(*args, &opts)
    cli = Jobim::CLI.new
    begin
      cli.parse(args)
      options = cli.options

      exit if options.nil?

      Jobim::Server.start options

    rescue OptionParser::InvalidOption => invalid_option
      puts ">>> Error: #{invalid_option}"
      puts cli.help

    rescue RuntimeError => runtime_error
      puts ">>> Failed to start server"
      puts ">> #{runtime_error}"
    end
  end

  def options
    @options ||= {
      :Daemonize => false,
      :Dir => Dir.pwd,
      :Host => '0.0.0.0',
      :Port => 5634,
      :Prefix => '/',
      :Quiet => false
    }
  end

  def parser
    @parser ||= OptionParser.new do |o|
      o.banner = "Usage: jobim [OPTION]... [DIRECTORY]"

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

      o.on "-P", "--prefix PATH", "Mount the app under PATH" do |path|
        options[:Prefix] = path
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

      o.separator ""
      o.separator "Jobim home page: <https://github.com/zellio/jobim/>"
      o.separator "Report bugs to: <https://github.com/zellio/jobim/issues>"
      o.separator ""
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
