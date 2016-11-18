require 'sinatra'
require 'sinatra/base'
require 'webrick'
require 'openssl'
require 'yconfig'
require_relative 'auth/token_authenticator.rb'
require_relative 'auth/security_helper.rb'

CONFIG = YConfig.new(File.join(Dir.pwd, 'lib', 'config')).parse 'config.yml'

class Filelocker < Sinatra::Base
  helpers do
    def protected!
      return if FileLockerExample::SecurityHelper.new(CONFIG).authorized? request
    rescue FileLockerExample::AuthError => e
      halt 401, e.message
    end
  end

  configure do
    disable :show_exceptions
  end

  get '/file/:filename' do |filename|
    protected!
    send_file(filename)
  end

  get '/sekrit' do
    protected!
    "hello moto".to_json
  end

  get '/' do
    { 'status' => 'active' }.to_json
  end

  error do
    'blessed mother above us, we have erred'
  end

  not_found do
    status 404
    'shitaki mushrooms, that did not work, file not found'
  end
end

webrick_options = {
  :Host               => '0.0.0.0',
  :Port               => 4567,
  :Logger             => WEBrick::Log.new($stderr, WEBrick::Log::DEBUG),
  :SSLEnable          => false,
}

def peel onion
  onion = onion.instance_variable_get '@app' while onion.instance_variable_defined? '@app'
  onion
end

Rack::Handler::WEBrick.run(Filelocker, webrick_options) do |server|
end
