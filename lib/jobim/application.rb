module Jobim::Application

  def self.run(*args, &opts)
    cli = Jobim::CLI.new
    begin
      cli.parse(args)

      exit if cli.exit

      Jobim::Server.start! cli.options
    rescue OptionParser::InvalidOption => invalid_option
      $stderr.puts ">>> Error: #{invalid_option}"
      $stderr.puts cli.help

    rescue RuntimeError => runtime_error
      $stderr.puts ">>> Failed to start server"
      $stderr.puts ">> #{runtime_error}"
    end
  end

end
