require 'yaml'

# Manages applications settings and configuration. Handles sane defaults and
# the loading / merging of configuration from files.
class Jobim::Settings
  VALID_KEYS = [:daemonize, :dir, :host, :port, :prefix, :quiet]

  attr_accessor *VALID_KEYS

  def initialize(run_load = true)
    update(
      daemonize: false,
      dir: Dir.pwd,
      host: '0.0.0.0',
      port: 3000,
      prefix: '/',
      quiet: false
    )

    load if run_load
  end

  def update(opts)
    VALID_KEYS.each { |key| send("#{key}=", opts[key]) unless opts[key].nil? }
    self
  end

  # Loads a configuration file in the yaml format into the settings object.
  #
  # @param [String] file path to the configuration file
  # @return [Jobim::Settings] self
  def load_file(file)
    opts = YAML.load_file(file)
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

    update(opts)
  end

  # Loads all configuration files from provided directory up. Defaults to the
  # current working directory of the program.
  #
  # @param [String] directory to load files from (defaults to Dir.pwd)
  # @return [Jobim::Settings] self
  def load(dir = Dir.pwd)
    dir = Pathname(File.expand_path(dir))
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

    self
  end
end
