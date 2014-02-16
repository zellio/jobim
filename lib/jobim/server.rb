require 'thin'
require 'rack'
require 'rack/rewrite'

# Http Server container class. Holds the Rack application definition and
# routing tables. Currently explicity leverages the Thin::Server for startup
# and operations. This should probably change.
class Jobim::Server

  # Static utility method for starting up a new instance of the Jobim::Server
  # class.
  #
  # @param opts [Hash] option hash for server configuration
  # @return [Jobim::Server] new running server instance
  def self.start!(opts)
    Jobim::Server.new(opts).start
  end

  attr_accessor :app, :opts, :server

  def initialize(opts, &block)
    @opts = opts

    yield self if block_given?
  end

  # Accessor for the server application.
  #
  # NB. This has been split into a memoized called to `build_app` becuase of
  # the way the Rack::Builder class handles scope in the context of
  # instance_eval instead of yield
  #
  # @return [Rack::Builder]
  def app
    @app ||= build_app(opts)
  end

  def opts
    @opts
  end

  # Memoized accessor method for the internal server instance.
  #
  # This is currently explicitly a Thin::Server, possibly should change into a
  # more generic mthod.
  #
  # @return [Thin::Server]
  def server
    if @server.nil?
      thin_app = Rack::Chunked.new(Rack::ContentLength.new(app))
      server = ::Thin::Server.new(opts[:Host], opts[:Port], thin_app)

      if opts[:Daemonize]
        server.pid_file = 'jobim.pid'
        server.log_file = 'jobim.log'
      end

      @server = server
    end

    @server
  end

  # Pass through delegation to the internal server start method. Handles
  # daemonizing the server before starting it if nessesary.
  def start
    Thin::Logging.silent = opts[:Quiet]

    puts ">>> Serving #{opts[:Dir]}"

    server.daemonize if opts[:Daemonize]
    server.start
  end

  private

  # Method to create a new instance of the Rack application. This is done for
  # scoping reason.
  def build_app(opts)
    Rack::Builder.new do
      use Rack::Rewrite do
        rewrite(%r{(.*)}, lambda do |match, env|
          request_path = env["PATH_INFO"]

          return match[1] if opts[:Prefix].length > request_path.length

          local_path = File.join(opts[:Dir], request_path[opts[:Prefix].length..-1])

          if File.directory?(local_path) and
              File.exists?(File.join(local_path, "index.html"))
            File.join(request_path, "index.html")
          else
            match[1]
          end
        end)
      end

      use Rack::CommonLogger, STDOUT

      map opts[:Prefix] do
        run Rack::Directory.new(opts[:Dir])
      end
    end
  end

end
