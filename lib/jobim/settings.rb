require 'yaml'

# Class for mangaging applications settings and configuration. Handles sane
# defaults and the loading / merging of configuration from files.
#
# Should possibly be made to be closer to a pass through to the hash class or
# to have better delegation and alleviate the need for @options
class Jobim::Settings

  attr_reader :options

  def initialize(run_load=true)
    load if run_load
  end

  # Option hash with memoized defualts
  #
  # @return [Hash]
  def options
    @options ||= {
      :Daemonize => false,
      :Dir => Dir.pwd,
      :Host => '0.0.0.0',
      :Port => 3000,
      :Prefix => '/',
      :Quiet => false
    }
  end

  # Loads a configuration file in the yaml format and merges the changes up
  # into the @options hash
  #
  # @param [String] file path to the configuration file
  # @return [Hash] the options hash
  def load_file(file)
    opts = YAML.load_file(file)
    opts.keys.each do |key|
      opts[(key.to_s.capitalize.to_sym rescue key) || key] = opts.delete(key)
    end

    if opts[:Dir]
      unless Pathname.new(opts[:Dir]).absolute?
        opts[:Dir] = File.expand_path("../#{opts[:Dir]}", file)
      end
    end

    options.merge!(opts)
  end

  # Loads all the of the configuration files from the CWD up.
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

    files.each {|file| self.load_file(file)}

    options
  end

end
