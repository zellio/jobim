require 'yaml'

class Jobim::Settings
  attr_reader :options

  def initialize(run_load = true)
    load if run_load
  end

  def options
    @options ||= {
      Daemonize: false,
      Dir: Dir.pwd,
      Host: '0.0.0.0',
      Port: 3000,
      Prefix: '/',
      Quiet: false
    }
  end

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
