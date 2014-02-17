require 'thin'
require 'rack'
require 'rack/rewrite'

class Jobim::Server
  def self.start!(opts)
    Jobim::Server.new(opts).start
  end

  attr_accessor :app, :opts, :server

  def initialize(opts, &block)
    @opts = opts

    yield self if block_given?
  end

  def app
    @app ||= build_app(opts)
  end

  def server
    if @server.nil?
      thin_app = Rack::Chunked.new(Rack::ContentLength.new(app))
      server = ::Thin::Server.new(opts[:host], opts[:port], thin_app)

      if opts[:daemonize]
        server.pid_file = 'jobim.pid'
        server.log_file = 'jobim.log'
      end

      @server = server
    end

    @server
  end

  def start
    Thin::Logging.silent = opts[:quiet]

    puts ">>> Serving #{opts[:dir]}"

    server.daemonize if opts[:daemonize]
    server.start
  end

  private

  def build_app(opts)
    Rack::Builder.new do
      use Rack::Rewrite do
        rewrite(/(.*)/, lambda do |match, env|
          request_path = env['PATH_INFO']

          return match[1] if opts[:prefix].length > request_path.length

          local_path = File.join(opts[:dir],
                                 request_path[opts[:prefix].length..-1])

          if File.directory?(local_path) &&
              File.exists?(File.join(local_path, 'index.html'))
            File.join(request_path, 'index.html')
          else
            match[1]
          end
        end)
      end

      use Rack::CommonLogger, STDOUT

      map opts[:prefix] do
        run Rack::Directory.new(opts[:dir])
      end
    end
  end
end
