require 'thin'
require 'rack'
require 'rack/rewrite'

# HTTP Server container. Contains the Rack application definition and routing
# tables. Class explicitly leverages `::Thin::Server` to create the HTTP
# server, this should possibly be changed.
class Jobim::Server

  # Utitly wrapper to create and start a new `Jobim::Server` instnace.
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

  # Memoized accessor for the server Rack application.
  #
  # NB. This has been split into a memoized called to `#build_app` becuase of
  # the way the `Rack::Builder` class handles scope in the context of
  # `instance_eval` instead of `yield`.
  #
  # @return [Rack::Builder]
  def app
    @app ||= build_app(opts)
  end

  def opts
    @opts
  end

  # Memoized accessor for the internal server instance.
  #
  # This is currently explicitly a `::Thin::Server`, possibly should change
  # into a more generic form.
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

  # Pass through delegation to the internal server object's start method.
  # Handles daemonizing the server before starting it if nessesary.
  def start
    Thin::Logging.silent = opts[:Quiet]

    puts ">>> Serving #{opts[:Dir]}"

    server.daemonize if opts[:Daemonize]
    server.start
  end

  private

  # Method to create a new instance of the Rack application. The creation
  # functionality has been broken out into its own method for scope
  # reason. `Rack::Builder` uses instance_eval which makes generating
  # applicaitons a pain.
  #
  # @param opts [Hash] option hash for server configuration
  # @return [Rack::Builder] Rack::Builder instance for application routing
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
