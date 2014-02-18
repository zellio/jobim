# Application container for initialization and execution of Jobim's
# resources. Generates a new `Jobim::CLI` instance, and then passes it off to
# a `Jobim::Server`. Good chance this will change in the future.
module Jobim::Application

  # Initializes and runs the CLI and Server
  #
  # @param args [Array<String>] list of args passed to the application
  # @param block [Block] dummy block object (Not used)
  def self.run(*args, &block)
    cli = Jobim::CLI.new
    begin
      cli.parse(args)

      exit if cli.exit

      Jobim::Server.start! cli.options
    rescue OptionParser::InvalidOption => invalid_option
      $stderr.puts ">>> Error: #{invalid_option}"
      $stderr.puts cli.help

    rescue RuntimeError => runtime_error
      $stderr.puts '>>> Failed to start server'
      $stderr.puts ">> #{runtime_error}"
    end
  end
end
