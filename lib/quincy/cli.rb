
require 'optparse'

class Quincy::CLI

  attr_reader :parser, :options

  def self.run!(*args, &opts)
    cli = Quincy::CLI.new
    begin
      cli.parse(args)
      cli.options
    rescue
      puts cli.help
      exit
    end
  end

  def options
    @options ||= { :dir => Dir.pwd }
  end

  def parser
    @parser ||= OptionParser.new do |o|
      o.banner = "quincy - TODO: FINISH ME"
      o.separator ""
      o.separator "Usage: quincy [OPTION]... [DIRECTORY]"
      o.separator ""
      # o.separator "Specific options:"
      # o.separator ""
      o.separator "General options:"
      o.on "-h", "--help", "Display this help message." do
        puts help
        exit
      end
      o.on "--version", "Display the version number" do
        options[:version] = Quincy::VERSION
        puts options[:version]
        exit
      end
    end
  end

  def parse(args)
    parser.parse!(args)
  end

  def help
    parser.to_s
  end
end
