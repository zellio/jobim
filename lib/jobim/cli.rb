require 'optparse'

class Jobim::CLI
  attr_reader :parser, :settings, :exit

  def settings
    @settings ||= Jobim::Settings.new
  end

  def options
    settings.options
  end

  def parser
    @parser ||= OptionParser.new do |o|
      o.banner = 'Usage: jobim [OPTION]... [DIRECTORY]'

      o.separator ''
      o.separator 'Specific options:'

      o.on('-a', '--address HOST',
           'bind to HOST address (default: 0.0.0.0)') do |host|
        options[:host] = host
      end

      o.on '-d', '--daemonize', 'Run as a daemon process' do
        options[:daemonize] = true
      end

      o.on('-p', '--port PORT', OptionParser::DecimalInteger,
           'use PORT (default: 3000)') do |port|
        fail OptionParser::InvalidArgument if port == 0
        options[:port] = port
      end

      o.on '-P', '--prefix PATH', 'Mount the app under PATH' do |path|
        options[:prefix] = path
      end

      o.on '-q', '--quiet', 'Silence all logging' do
        options[:quiet] = true
      end

      o.separator ''
      o.separator 'General options:'

      o.on '-h', '--help', 'Display this help message.' do
        @exit = true
        puts help
      end
      o.on '--version', 'Display the version number' do
        @exit = true
        puts "#{Jobim::VERSION}\n"
      end

      o.separator ''
      o.separator 'Jobim home page: <https://github.com/zellio/jobim/>'
      o.separator 'Report bugs to: <https://github.com/zellio/jobim/issues>'
      o.separator ''
    end
  end

  def parse(args)
    parser.parse!(args)
    options[:dir] = File.expand_path(args[0]) if args.length == 1
  end

  def help
    parser.to_s
  end
end
