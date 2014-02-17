require 'yaml'

class Jobim::Settings

  attr_reader :options

  def initialize(run_load=true)
    load if run_load
  end

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

  def load_file(file)
    opts = YAML.load_file(file)
    opts.keys.each do |key|
      opts[(key.to_s.downcase.to_sym rescue key) || key] = opts.delete(key)
    end

    if opts[:dir]
      unless Pathname.new(opts[:dir]).absolute?
        opts[:dir] = File.expand_path("../#{opts[:dir]}", file)
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

    files.each {|file| self.load_file(file)}

    options
  end

end
