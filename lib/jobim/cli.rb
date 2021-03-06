require 'optparse'

# Command line interface for the Jobim application. Utilizes optparse to
# manage user arguments and populates a `Jobim::Settings` object.
class Jobim::CLI
  attr_reader :parser, :settings, :exit, :options

  # Memoized, lazy accessor for the settings object.
  #
  # @return [Jobim::Settings]
  def settings
    @settings ||= Jobim::Settings.new(options)
  end

  # Memoized, lazy accessor for the options hash.
  #
  # @return [Hash] options generated from #parse
  def options
    @options ||= {
      daemonize: false,
      dir: Dir.pwd,
      host: '0.0.0.0',
      port: 3000,
      prefix: '/',
      quiet: false,
      conf_dir: Dir.pwd
    }
  end

  # Memoized accessor for the `OptionParser` object. It is generated only when
  # called upon. See the readme for information about the command flags.
  #
  # @return [OptionParser]
  def parser
    @parser ||= OptionParser.new do |o|
      o.banner = 'Usage: jobim [OPTION]... [DIRECTORY]'

      o.separator ''
      o.separator 'Specific options:'

      o.on('-a', '--address HOST',
           'bind to HOST address (default: 0.0.0.0)') do |host|
        options[:host] = host
      end

      o.on('-c', '--[no-]config [PATH]',
           'Disable config loading or specify path to load from') do |v|
        options[:conf_dir] = v.nil? ? Dir.pwd : v
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

  # Runs the parse method of the value returned by the `#parser` method. This
  # is done in a manner destructive to the passed args `Array`. If there is a
  # trailing value after parsing is completed it is treated as the `:dir`
  # option.
  #
  # @param [Array<String>] args to be paresed
  # @return [NilClass] sentitinal nil value
  def parse(args)
    parser.parse!(args)
    options[:dir] = File.expand_path(args[0]) if args.length == 1

    nil
  end

  # Help documentation of the program.
  #
  # @return [String]
  def help
    parser.to_s
  end
end
