require 'yaml'

# Manages applications settings and configuration. Handles sane defaults and
# the loading / merging of configuration from files.
#
# Should possibly be made to be closer to a pass through to the hash class or
# to have better delegation and alleviate the need for @options
class Jobim::Settings
  attr_reader :options

  def initialize(run_load = true)
    load if run_load
  end

  # Option hash with memoized defualts.
  #
  # @return [Hash]
  def options
    @options ||= {
      daemonize: false,
      dir: Dir.pwd,
      host: '0.0.0.0',
      port: 3000,
      prefix: '/',
      quiet: false
    }
  end

  # Loads a configuration file in the yaml format and merges the changes up
  # into the `@options` hash.
  #
  # @param [String] file path to the configuration file
  # @return [Hash] the options hash
  def load_file(file)
    opts = YAML.load_file(file) || {}
    opts.keys.each do |key|
      begin
        opts[key.to_s.downcase.to_sym || key] = opts.delete(key)
      rescue
        opts[key] = opts.delete(key)
      end
    end

    if opts[:dir]
      unless Pathname.new(opts[:dir]).absolute?
        opts[:dir] = File.expand_path("../#{opts[:dir]}", file)
      end
    end

    options.merge!(opts)
  end

  # Loads all the of the configuration files from the CWD up. This should
  # probably be changed to take an argument for dir instead of it always using
  # working directory.
  #
  # @return [Hash] the options hash
  def load
    dir = Pathname(Dir.pwd)
    files = []

    loop do
      file = File.expand_path('.jobim.yml', dir)
      if File.exists? file
        files.unshift(file)
      else
        file = File.expand_path('.jobim.yaml', dir)
        files.unshift(file) if File.exists? file
      end

      break if dir.root?

      dir = dir.parent
    end

    files.each { |file| load_file(file) }

    options
  end
end
