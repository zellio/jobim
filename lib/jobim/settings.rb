require 'yaml'

class Jobim::Settings

  attr_reader :options

  def initialize
    load
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

  def load_file(file)
    opts = YAML.load_file(file)
    opts.keys.each do |key|
      opts[(key.to_s.capitalize.to_sym rescue key) || key] = opts.delete(key)
    end

    options.merge!(opts)
  end

  def load
    dir = Pathname('.').realpath
    files = []

    loop do
      file = File.expand_path('.jobim.yaml', dir)

      files.unshift(file) if File.exists? file

      break if dir.root?

      dir = dir.parent
    end

    files.each {|file| self.load_file(file)}

    options
  end

end
