require 'rack'
require 'rack/rewrite'

class Jobim::Server

  def self.start!(opts)
    Jobim::Server.new(opts).start
  end

  attr_accessor :app, :opts

  def initialize(opts, &block)
    @opts = opts

    yield self if block_given?
  end

  def app
    @app ||= build_app(opts)
  end

  def opts
    @opts
  end

  def start
    puts ">>> Serving #{opts[:Dir]}"

    Rack::Handler::Thin.run(app, opts) do |server|
      if opts[:Daemonize]
        server.pid_file = 'jobim.pid'
        server.log_file = 'jobim.log'
        server.daemonize
      end

      Thin::Logging.silent = opts[:Quiet]
    end
  end

  private

  def build_app(opts)
    Rack::Builder.new do
      use Rack::Rewrite do
        rewrite(%r{(.*)}, lambda do |match, env|
          request_path = env["REQUEST_PATH"]

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
