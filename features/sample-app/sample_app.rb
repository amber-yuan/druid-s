require 'rubygems'
require 'rack'
require 'rackup'
require 'webrick'

class SampleApp

  def self.start(host, port)
    Rackup::Handler::WEBrick.run new,
                               :Host => host,
                               :Port => port,
                               :Logger => ::WEBrick::Log.new(RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null'),
                               :AccessLog => [nil, nil]
  end

  def initialize
    @public = File.expand_path("../public", __FILE__)
  end

  def call(env)
    req = Rack::Request.new(env)

    case req.path
    when "/"
      [200, {}, ["Sample Application"]]
    when "/compute"
      sleep 5
      resp = eval(req.params['calculator-expression']).to_s
      [200, {}, [resp]]
    else
      @public.call(env)
    end
  end

end
